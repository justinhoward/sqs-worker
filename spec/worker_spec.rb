# frozen_string_literal: true

RSpec.describe SqsWorker::Worker do
  it 'calls received jobs' do
    client = SqsWorker::Mock::Client.new
    client.jobs = [
      SqsWorker::Mock::Job.new('foo'),
      SqsWorker::Mock::Job.new('bar')
    ]
    queue = SqsWorker::Queue.new(client, 'test')
    worker = described_class.new(queue)
    worker.poll

    expect(client.jobs[0].calls).to eq(1)
    expect(client.jobs[1].calls).to eq(1)
  end
end
