# frozen_string_literal: true

RSpec.describe SqsWorker::Serializer::Json do
  let(:json) { described_class.new }

  it 'serializes args to JSON' do
    expect(json.serialize([1, 2, 3])).to eq('[1,2,3]')
  end

  it 'deserializes args from JSON' do
    expect(json.deserialize('[{"foo":"bar"}]')).to eq([{ 'foo' => 'bar' }])
  end

  it 'throws a SerializerError if given a circular object' do
    foo = {}
    bar = { foo: foo }
    foo[:bar] = bar

    expect { json.serialize(foo) }.to raise_error(SqsWorker::SerializerError)
  end

  it 'throws a SerializerError if given invalid JSON' do
    expect { json.deserialize('{') }.to raise_error(SqsWorker::SerializerError)
  end
end
