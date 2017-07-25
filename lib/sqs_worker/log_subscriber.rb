# frozen_string_literal: true

module SqsWorker
  class LogSubscriber
    def self.subscribed_events
      %w[
        client.execute
        client.poll
        client.receive
        client.url
      ]
    end

    def initialize(logger)
      @logger = logger
    end

    def client_execute(params, event)
    end

    def client_poll(params, event)
    end

    def client_receive(params, event)
    end

    def client_url(params, event)
    end
  end
end
