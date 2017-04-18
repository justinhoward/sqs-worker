# frozen_string_literal: true

module SqsWorker
  class Queue
    attr_reader :name

    def initialize(client, name)
      @client = client
      @name = name
    end

    def add(job, run_at: nil)
      @client.execute(Plan.new(job, self, run_at: run_at))
    end

    def poll(&block)
      @client.poll(@name, &block)
    end

    def url
      @url ||= @client.url(name)
    end
  end
end
