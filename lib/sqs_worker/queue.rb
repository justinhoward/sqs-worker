# frozen_string_literal: true

module SqsWorker
  class Queue
    attr_reader :name

    def initialize(client, name)
      @client = client
      @name = name
    end

    def add(job)
      dispatch('add', job: job)
      @client.execute(Plan.new(job, url))
    end

    def schedule(job, run_at)
      dispatch('schedule', job: job, run_at: run_at)
      @client.execute(Plan.new(job, url, run_at: run_at))
    end

    def poll(&block)
      dispatch('poll')
      @client.poll(url, &block)
    end

    def url
      @url ||= @client.url(name)
    end

    private

    def dispatch(event, params = {})
      @client.observer.dispatch("queue.#{event}", params)
    end
  end
end
