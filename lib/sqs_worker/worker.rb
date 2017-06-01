# frozen_string_literal: true

module SqsWorker
  class Worker
    def initialize(queue)
      @queue = queue
    end

    def poll
      @queue.poll(&:call)
    end
  end
end
