# frozen_string_literal: true

module SqsWorker
  module Serializer
    class Json
      def serialize(args)
        JSON.dump(args)
      end

      def unserialize(body)
        JSON.parse(body)
      end
    end
  end
end
