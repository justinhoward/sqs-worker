# frozen_string_literal: true

module ActiveJob
  module QueueAdapters
    class SqsWorkerAdapter
      class << self
        extend Forwardable
        def_delegators :instance, :enqueue, :enqueue_at

        private

        def instance
          @instance ||= new
        end
      end

      def initialize(client = SqsWorker.default_client)
        @client = client
      end

      def enqueue(job)
        client.execute(plan(job))
      end

      def enqueue_at(job, time)
        client.execute(plan(job, run_at: time))
      end

      private

      def plan(job, run_at: nil)
        Plan.new(
          SqsWorker::ActiveJob.new(job),
          queue(job.queue),
          run_at: run_at
        )
      end

      def queue(name)
        @queues[name] ||= @client.queue(name)
      end
    end
  end
end
