# frozen_string_literal: true

module SqsWorker
  class << self
    attr_writer :default_client

    def default_client
      @default_client ||= Client.new
    end
  end
end

require 'aws-sdk'

require 'sqs_worker/version'

require 'sqs_worker/client'
require 'sqs_worker/error'
require 'sqs_worker/message'
require 'sqs_worker/plan'
require 'sqs_worker/queue'
require 'sqs_worker/serializer'
require 'sqs_worker/worker'

require 'sqs_worker/rails' if Object.const_defined?(:Rails)
