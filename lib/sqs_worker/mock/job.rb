# frozen_string_literal: true

module SqsWorker
  module Mock
    class Job
      attr_accessor :args

      def self.from_args(*args)
        new(*args)
      end

      def initialize(*args)
        @args = args
      end

      def to_args
        @args
      end
    end
  end
end
