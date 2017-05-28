# frozen_string_literal: true

module SqsWorker
  class ActiveJob
    def self.from_args(hash)
      new(ActiveJob::Base.deserialize(hash))
    end

    def initialize(job)
      @origin = job
    end

    def call
      @origin.perform_now
    end

    def to_args
      [@origin.serialize]
    end
  end
end
