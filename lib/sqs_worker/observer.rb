# frozen_string_literal: true

module SqsWorker
  class Observer
    def initialize
      @subscribers = {}
    end

    def dispatch(event, params = {})
      return unless @subscribers[event]
      @subscribers[event].each { |sub| sub.call(event, params) }
    end

    def subscribe(event, &block)
      @subscribers[event] ||= []
      @subscribers[event] << block
    end
  end
end
