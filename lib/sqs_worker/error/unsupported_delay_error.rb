
# frozen_string_literal: true

module SqsWorker
  class UnsupportedDelayError < Error
    MESSAGE = 'Job %s uses a delay, which is unsupported.'

    def initialize(job_class)
      super(format(MESSAGE, job_class))
    end
  end
end
