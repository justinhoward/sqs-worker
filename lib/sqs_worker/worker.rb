# frozen_string_literal: true

module SqsWorker
  class Worker
    def initialize(queue, client = SqsWorker.default_client)
      @client = client
      @queue = queue
    end

    def poll
      @client.poll(@queue, &:call)
    end
  end
end
