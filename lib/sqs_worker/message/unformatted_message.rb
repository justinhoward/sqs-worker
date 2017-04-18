# frozen_string_literal: true

module SqsWorker
  module Message
    class UnformattedMessage
      REQUIRED_ATTRS = %w[job_class serializer_class sqs_worker_version].freeze

      def initialize(sqs_message, serializer = JsonSerializer.new)
        @sqs_message = sqs_message
        @serializer = serializer

        check_attrs
        check_serializer
      end

      def job
        @job ||= get_class(attrs['job_class']).from_args(*args)
      end

      private

      def check_attrs
        REQUIRED_ATTRS.each do |name|
          raise MissingAttributeError.new(name) if attrs[name].nil?
        end
      end

      def check_serializer
        message_serializer = get_class(attrs['serializer_class'])
        if message_serializer != @serializer.class
          raise InvalidSerializerError.new(
            @serializer.class,
            message_serializer
          )
        end
      end

      def get_class(name)
        raise MissingClassError.new(name) unless Object.const_defined?(name)
        Object.const_get(name)
      end

      def args
        @args ||= @serializer.unserialize(@sqs_message[:body])
      end

      def attrs
        raw_attrs = @sqs_message[:message_attributes]
        raw_attrs.each_with_object({}) do |(key, value), obj|
          obj[key] = value[:string_value]
        end
      end
    end
  end
end
