require 'rspec'
require 'fluent/pipeline/helpers'
require 'fluent/pipeline/errors'

class TestClass
  include Fluent::Helpers

  def test_method
    with_undefined_method_handle do
      callback_method
    end
  end

  def callback_method; end
end


describe 'Fluent::Helpers' do
  let(:object) { TestClass.new }

  it 'raise a specific exception for undefined methods ' do
    allow(object).to receive(:callback_method).and_raise(NoMethodError.new('', 'callback_method'))
    expect { object.test_method }.to raise_error(Fluent::UndefinedPipeMethod, /Undefined method `callback_method` for pipe/)
  end

  it 'raises no related to no method error exceptions' do
    allow(object).to receive(:callback_method).and_raise(StandardError)
    expect { object.test_method }.to raise_error StandardError
  end
end
