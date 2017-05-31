# frozen_string_literal: true

module SqsWorker
  module Mock
    class Client
      attr_reader :calls

      def initialize(account: '123456789')
        @account = account
        @calls = []
      end

      def queue(name)
        @calls << [:queue, name]
        Queue.new(self, name)
      end

      def execute(plan)
        @calls << [:execute, plan]
      end

      def poll(queue)
        @calls << [:poll, queue, Proc.new]
      end

      def url(name)
        @calls << [:url, name]
        "https://queue.amazonaws.com/#{@account}/#{name}"
      end
    end
  end
end
