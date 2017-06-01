# frozen_string_literal: true

# rubocop: disable BlockLength
RSpec.describe SqsWorker::Mock::Client do
  it 'records calls to execute' do
    client = described_class.new
    plan = SqsWorker::Plan.new(
      SqsWorker::Mock::Job.new,
      SqsWorker::Queue.new(client, 'test')
    )
    client.execute(plan)
    expect(client.calls).to eq([[:execute, plan]])
  end

  it 'creates a queue by name' do
    client = described_class.new(account: 'foobar123')
    queue = client.queue('test')

    expect(client.calls).to eq([[:queue, 'test']])
    expect(queue.name).to eq('test')
    expect(queue.url).to eq('https://queue.amazonaws.com/foobar123/test')
  end

  it 'polls jobs given to it' do
    client = described_class.new
    client.jobs = [
      SqsWorker::Mock::Job.new(1),
      SqsWorker::Mock::Job.new(2)
    ]
    queue = SqsWorker::Queue.new(client, 'test')
    jobs = []
    client.poll(queue) do |job|
      jobs << job
    end
    expect(jobs.map(&:args)).to eq([[1], [2]])
  end

  it 'gets a url for queue name' do
    client = described_class.new(account: 'test123')
    expect(client.url('foo')).to eq('https://queue.amazonaws.com/test123/foo')
  end
end
