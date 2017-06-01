# frozen_string_literal: true

module SqsWorker
  module Mock
    class Job
      attr_accessor :args, :called

      def self.from_args(*args)
        new(*args)
      end

      def initialize(*args)
        @args = args
        @called = 0
      end

      def call
        @called += 1
      end

      def to_args
        @args
      end
    end
  end
end
