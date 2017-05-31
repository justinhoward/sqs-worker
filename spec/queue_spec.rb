# frozen_string_literal: true

# rubocop:disable BlockLength
RSpec.describe SqsWorker::Queue do
  let(:client) { SqsWorker::Mock::Client.new }

  it 'executes a plan when adding a job' do
    queue = described_class.new(client, 'test')
    job = SqsWorker::Mock::Job.new
    time = Time.now

    queue.add(job, run_at: time)

    expect(client.calls).to match([[:execute, instance_of(SqsWorker::Plan)]])
    expect(client.calls[0][1].job).to eq(job)
    expect(client.calls[0][1].queue).to eq(queue)
    expect(client.calls[0][1].run_at).to eq(time)
  end

  it 'asks the client to poll' do
    queue = described_class.new(client, 'test')
    poller = -> {}
    queue.poll(&poller)

    expect(client.calls).to eq([[:poll, queue, poller]])
  end

  it 'gets its URL' do
    client = SqsWorker::Mock::Client.new(account: '123456789')
    queue = described_class.new(client, 'test')
    expect(queue.url).to eq('https://queue.amazonaws.com/123456789/test')
  end
end
