# frozen_string_literal: true

module SqsWorker
  module Mock
    class Client
      attr_reader :calls
      attr_accessor :jobs
      attr_accessor :observer

      def initialize(account: '123456789')
        @account = account
        @observer = Observer.new
        @calls = []
        @jobs = []
      end

      def execute(plan)
        @calls << [:execute, plan]
      end

      def poll(url)
        @calls << [:poll, url, Proc.new]
        @jobs.each { |job| yield job }
      end

      def url(name)
        @calls << [:url, name]
        "https://queue.amazonaws.com/#{@account}/#{name}"
      end
    end
  end
end
