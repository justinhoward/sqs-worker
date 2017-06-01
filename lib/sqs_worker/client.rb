# frozen_string_literal: true

module SqsWorker
  class Client
    attr_accessor :observer

    def initialize(
      format: Message::Format.new,
      observer: Observer.new,
      sqs: Aws::SQS::Client.new
    )
      @format = format
      @observer = observer
      @sqs = sqs
    end

    def execute(plan)
      dispatch('execute', plan: plan)
      @sqs.send_message(@format.format(plan))
    end

    def poll(url)
      dispatch('poll', url: url)
      poller(url).poll do |message|
        dispatch('receive', url: url, message: message)
        yield @format.unformat(message.to_h)
      end
    end

    def url(name)
      dispatch('url', name: name)
      @sqs.get_queue_url(queue_name: name).queue_url
    end

    private

    def poller(url)
      Aws::SQS::QueuePoller.new(url, client: @sqs)
    end

    def dispatch(event, params = {})
      @observer.dispatch("client.#{event}", params)
    end
  end
end
