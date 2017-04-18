# frozen_string_literal: true

module SqsWorker
  class InvalidSerializerError < Error
    MESSAGE = 'Invalid serializer %s. Expected serializer %s.'

    def initialize(expected, actual)
      super(format(MESSAGE, actual, expected))
    end
  end
end
