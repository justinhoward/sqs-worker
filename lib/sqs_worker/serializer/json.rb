# frozen_string_literal: true

module SqsWorker
  module Serializer
    class Json
      def serialize(args)
        JSON.generate(args)
      rescue JSON::JSONError
        raise SerializerError, 'Could not serialize args to JSON'
      end

      def deserialize(body)
        JSON.parse(body)
      rescue JSON::JSONError
        raise SerializerError, 'Could not deserialize args from JSON'
      end
    end
  end
end
