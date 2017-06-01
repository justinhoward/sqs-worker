# frozen_string_literal: true

# rubocop:disable BlockLength
RSpec.describe SqsWorker::Queue do
  let(:client) { SqsWorker::Mock::Client.new(account: 'abc123') }

  it 'executes a plan when adding a job' do
    queue = described_class.new(client, 'test')
    job = SqsWorker::Mock::Job.new

    queue.add(job)

    expect(client.calls[0]).to eq([:url, 'test'])
    expect(client.calls[1]).to match([:execute, instance_of(SqsWorker::Plan)])
    expect(client.calls[1][1].job).to eq(job)
    expect(client.calls[1][1].url)
      .to eq('https://queue.amazonaws.com/abc123/test')
    expect(client.calls[1][1].run_at).to eq(nil)
  end

  it 'schedules a plan' do
    queue = described_class.new(client, 'test')
    job = SqsWorker::Mock::Job.new
    time = Time.now + 10

    queue.schedule(job, time)

    expect(client.calls[0]).to eq([:url, 'test'])
    expect(client.calls[1]).to match([:execute, instance_of(SqsWorker::Plan)])
    expect(client.calls[1][1].job).to eq(job)
    expect(client.calls[1][1].url)
      .to eq('https://queue.amazonaws.com/abc123/test')
    expect(client.calls[1][1].run_at).to eq(time)
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
