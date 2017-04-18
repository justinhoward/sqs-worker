# frozen_string_literal: true

class TestJob
  attr_accessor :args

  def self.from_args(*args)
    new(*args)
  end

  def initialize(*args)
    @args = args
  end

  def to_args
    @args
  end
end

# rubocop:disable BlockLength
RSpec.describe SqsWorker::Client do
  let(:sqs) { Aws::SQS::Client.new(stub_responses: true) }
  let(:client) { described_class.new(sqs: sqs) }

  it 'gets a queue' do
    foo = client.queue('foo')
    expect(foo.name).to eq('foo')
  end

  it 'executes a plan' do
    sqs.stub_responses(
      :get_queue_url,
      queue_url: 'https://queue.amazonaws.com/123/planner'
    )
    queue = SqsWorker::Queue.new(client, 'planner')
    plan = SqsWorker::Plan.new(
      TestJob.new(1, 2, 3),
      queue,
      run_at: Time.now + 3
    )

    expect(sqs).to receive(:send_message).with(
      queue_url: 'https://queue.amazonaws.com/123/planner',
      message_body: '[1,2,3]',
      message_attributes: {
        'serializer_class' => {
          data_type: 'String',
          string_value: 'SqsWorker::Serializer::Json'
        },
        'job_class' => {
          data_type: 'String',
          string_value: 'TestJob'
        },
        'sqs_worker_version' => {
          data_type: 'String',
          string_value: SqsWorker::VERSION
        }
      },
      delay_seconds: 3
    )

    client.execute(plan)
  end

  it 'gets a queue url' do
    sqs.stub_responses(
      :get_queue_url,
      queue_url: 'https://queue.amazonaws.com/9999/my-queue'
    )

    expect(client.url('foo')).to eq('https://queue.amazonaws.com/9999/my-queue')
  end

  it 'polls for jobs' do
    sqs.stub_responses(
      :get_queue_url,
      queue_url: 'https://queue.amazonaws.com/9876/jobs'
    )

    sqs.stub_responses(
      :receive_message,
      messages: [
        {
          body: '[1,2,3]',
          message_attributes: {
            'sqs_worker_version' => {
              data_type: 'String',
              string_value: SqsWorker::VERSION
            },
            'job_class' => {
              data_type: 'String',
              string_value: 'TestJob'
            },
            'serializer_class' => {
              data_type: 'String',
              string_value: 'SqsWorker::Serializer::Json'
            }
          }
        }
      ]
    )

    queue = SqsWorker::Queue.new(client, 'jobs')

    job = nil
    client.poll(queue) do |j|
      job = j
      throw :stop_polling
    end

    expect(job.args).to eq([1, 2, 3])
  end
end
