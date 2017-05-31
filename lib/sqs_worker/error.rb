# frozen_string_literal: true

module SqsWorker
  class Error < RuntimeError
  end
end

require 'sqs_worker/error/invalid_serializer_error'
require 'sqs_worker/error/missing_attribute_error'
require 'sqs_worker/error/missing_class_error'
require 'sqs_worker/error/serializer_error'
