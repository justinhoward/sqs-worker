# frozen_string_literal: true

module SqsWorker
  module Message
    class PlanMessage
      def initialize(plan, serializer = Serializer::Json.new)
        @plan = plan
        @serializer = serializer
      end

      def to_h
        {
          queue_url: @plan.queue.url,
          message_body: @serializer.serialize(@plan.job.to_args),
          message_attributes: attributes,
          delay_seconds: @plan.run_at ? (@plan.run_at - Time.now).ceil : nil
        }
      end

      private

      def attributes
        {
          'serializer_class' => string_attr(@serializer.class.name),
          'job_class' => string_attr(@plan.job.class.name),
          'sqs_worker_version' => string_attr(VERSION)
        }
      end

      def string_attr(value)
        { data_type: 'String', string_value: value }
      end
    end
  end
end
