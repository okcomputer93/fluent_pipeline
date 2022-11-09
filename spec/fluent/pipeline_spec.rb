# frozen_string_literal: true

require 'fluent/pipeline'

module Fluent
  class PipeAdder
    def call(count)
      count + 1
    end
  end
end

module Fluent
  class CustomPipeAdder
    def handle(count)
      count + 1
    end
  end
end

RSpec.describe Fluent::Pipeline do
  it 'should process an item through a pipe' do
    Fluent::Pipeline.
      dispatch(0).
      through(Fluent::PipeAdder.new).
      then(->(new_count) { expect(new_count).to eq(1) })
  end

  it 'should process an item through multiple pipes' do
    Fluent::Pipeline.
      dispatch(0).
      through([Fluent::PipeAdder.new, Fluent::PipeAdder.new]).
      then(->(new_count) { expect(new_count).to eq(2) })
  end

  it 'should process an item through a lambda as a pipe' do
    Fluent::Pipeline.
      dispatch(0).
      through(->(count) { count + 1 }).
      then(->(new_count) { expect(new_count).to eq(1) })
  end

  it 'should process an item through lambdas' do
    Fluent::Pipeline.
      dispatch(0).
      through([->(count) { count + 1 }, ->(count) { count + 1 }]).
      then(->(new_count) { expect(new_count).to eq(2) })
  end

  it 'should process an item via another handler method' do
    Fluent::Pipeline.
      dispatch(0).
      through([Fluent::CustomPipeAdder.new, Fluent::CustomPipeAdder.new]).
      via(:handle).
      then(->(new_count) { expect(new_count).to eq(2) })
  end
end
