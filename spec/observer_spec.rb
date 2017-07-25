# frozen_string_literal: true

class MockSubscriber
  def self.subscribed_events
    %w[test.hello test.goodbye]
  end

  attr_reader :events

  def initialize
    @events = []
  end

  def test_hello(params, event)
    @events << [params, event]
  end

  def test_goodbye(params, event)
    @events << [params, event]
  end
end

# rubocop:disable BlockLength
RSpec.describe SqsWorker::Observer do
  it 'dispatches events to subscribers' do
    obs = described_class.new
    message = nil
    name = nil
    obs.subscribe('boom') do |params, event|
      name = event
      message = params[:hello]
    end
    obs.dispatch('boom', hello: 'world')
    expect(name).to eq('boom')
    expect(message).to eq('world')
  end

  it 'dispatches events when no subscribers' do
    obs = described_class.new
    obs.dispatch('echo', hello: 'hello, hello...')
  end

  it 'adds a listener for every subscriber method' do
    obs = described_class.new
    subscriber = MockSubscriber.new
    obs.register(subscriber)
    obs.dispatch('test.hello', greeting: 'hi')
    obs.dispatch('test.goodbye', farewell: 'bye')
    expect(subscriber.events).to eq([
      [{ greeting: 'hi' }, 'test.hello'],
      [{ farewell: 'bye' }, 'test.goodbye']
    ])
  end
end
