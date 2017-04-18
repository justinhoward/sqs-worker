# frozen_string_literal: true

module SqsWorker
  class Plan
    attr_reader :job, :queue, :run_at

    def initialize(job, queue, run_at: nil)
      @job = job
      @queue = queue
      @run_at = run_at
    end
  end
end
