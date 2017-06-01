# frozen_string_literal: true

RSpec.describe SqsWorker::Mock::Job do
  it 'records args given in initializer' do
    expect(described_class.new('foo', 'bar').to_args).to eq(%w[foo bar])
  end

  it 'can be restored from args' do
    expect(described_class.from_args(1, 2, 3).args).to eq([1, 2, 3])
  end

  it 'records number of calls' do
    job = described_class.new
    job.call
    job.call
    expect(job.calls).to eq(2)
  end
end
