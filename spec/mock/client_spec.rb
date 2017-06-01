# frozen_string_literal: true

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

  it 'polls jobs given to it' do
    client = described_class.new
    client.jobs = [
      SqsWorker::Mock::Job.new(1),
      SqsWorker::Mock::Job.new(2)
    ]
    jobs = []
    client.poll('https://queue.amazonaws.com/foobar123/test') do |job|
      jobs << job
    end
    expect(jobs.map(&:args)).to eq([[1], [2]])
  end

  it 'gets a url for queue name' do
    client = described_class.new(account: 'test123')
    expect(client.url('foo')).to eq('https://queue.amazonaws.com/test123/foo')
  end
end
