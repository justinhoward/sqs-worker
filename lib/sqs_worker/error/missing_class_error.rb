
# frozen_string_literal: true

module SqsWorker
  class MissingClassError < Error
    MESSAGE = 'Missing class named %s'

    def initialize(name)
      super(format(MESSAGE, name))
    end
  end
end
