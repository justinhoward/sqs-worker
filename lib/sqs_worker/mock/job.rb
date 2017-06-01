# frozen_string_literal: true

module SqsWorker
  module Mock
    class Job
      attr_accessor :args, :calls

      def self.from_args(*args)
        new(*args)
      end

      def initialize(*args)
        @args = args
        @calls = 0
      end

      def call
        @calls += 1
      end

      def to_args
        @args
      end
    end
  end
end
