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

    def queue(name)
      Queue.new(self, name)
    end

    def execute(plan)
      @sqs.send_message(@format.format(plan))
    end

    def poll(queue)
      poller(queue.name).poll do |message|
        yield @format.unformat(message.to_h)
      end
    end

    def url(name)
      @sqs.get_queue_url(queue_name: name).queue_url
    end

    private

    def poller(name)
      Aws::SQS::QueuePoller.new(url(name), client: @sqs)
    end
  end
end
