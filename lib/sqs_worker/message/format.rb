# frozen_string_literal: true

module SqsWorker
  module Message
    class Format
      def initialize(serializer = Serializer::Json.new)
        @serializer = serializer
      end

      def format(plan)
        Message::PlanMessage.new(plan, @serializer).to_h
      end

      def unformat(sqs_message)
        Message::UnformattedMessage.new(sqs_message, @serializer).job
      end
    end
  end
end
