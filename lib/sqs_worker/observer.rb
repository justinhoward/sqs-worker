# frozen_string_literal: true

module SqsWorker
  class Observer
    def initialize
      @subscribers = {}
    end

    def dispatch(event, params = {})
      event = event.to_s
      return unless @subscribers[event]
      @subscribers[event].each { |sub| sub.call(params, event) }
    end

    def subscribe(event, &block)
      event = event.to_s
      @subscribers[event] ||= []
      @subscribers[event] << block
    end

    def register(subscriber)
      subscriber.class.subscribed_events.each do |event|
        subscribe(event, &subscriber.method(event.to_s.gsub(/[^a-z_]/, '_')))
      end
    end
  end
end
