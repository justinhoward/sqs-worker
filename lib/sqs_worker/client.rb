# frozen_string_literal: true

module SqsWorker
  class Client
    def initialize(
      format: Message::Format.new,
      sqs: Aws::SQS::Client.new
    )
      @format = format
      @sqs = sqs
    end

    def execute(plan)
      @sqs.send_message(@format.format(plan))
    end

    def poll(url, &block)
      poller(url).poll do |message|
        receive(message, &block)
      end
    end

    def url(name)
      @sqs.get_queue_url(queue_name: name).queue_url
    end

    private

    def poller(url)
      Aws::SQS::QueuePoller.new(url, client: @sqs)
    end

    def receive(message)
      yield @format.unformat(message.to_h)
    end
  end
end
