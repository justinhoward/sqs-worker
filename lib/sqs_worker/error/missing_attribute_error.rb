# frozen_string_literal: true

module SqsWorker
  class MissingAttributeError < Error
    MESSAGE = 'Missing message attribute %s'

    def initialize(name)
      super(format(MESSAGE, name))
    end
  end
end
