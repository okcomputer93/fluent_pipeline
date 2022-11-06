# frozen_string_literal: true

require 'simple/pipeline'

module Simple
  class PipeAdder
    def call(count)
      count + 1
    end
  end
end

module Simple
  class CustomPipeAdder
    def handle(count)
      count + 1
    end
  end
end

RSpec.describe Simple::Pipeline do
  it 'should process an item through a pipe' do
    Simple::Pipeline.
      dispatch(0).
      through(Simple::PipeAdder.new).
      then(->(new_count) { expect(new_count).to eq(1) })
  end

  it 'should process an item through multiple pipes' do
    Simple::Pipeline.
      dispatch(0).
      through([Simple::PipeAdder.new, Simple::PipeAdder.new]).
      then(->(new_count) { expect(new_count).to eq(2) })
  end

  it 'should process an item through a lambda as a pipe' do
    Simple::Pipeline.
      dispatch(0).
      through(->(count) { count + 1 }).
      then(->(new_count) { expect(new_count).to eq(1) })
  end

  it 'should process an item through lambdas' do
    Simple::Pipeline.
      dispatch(0).
      through([->(count) { count + 1 }, ->(count) { count + 1 }]).
      then(->(new_count) { expect(new_count).to eq(2) })
  end

  it 'should process an item via another handler method' do
    Simple::Pipeline.
      dispatch(0).
      through([Simple::CustomPipeAdder.new, Simple::CustomPipeAdder.new]).
      via(:handle).
      then(->(new_count) { expect(new_count).to eq(2) })
  end
end
