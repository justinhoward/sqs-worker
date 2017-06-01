# frozen_string_literal: true

module SqsWorker
  class Plan
    attr_reader :job, :url, :run_at

    def initialize(job, url, run_at: nil)
      @job = job
      @url = url
      @run_at = run_at
    end
  end
end
