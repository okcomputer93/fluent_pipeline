# frozen_string_literal: true

require 'fluent/pipeline/version'
require 'fluent/pipeline/helpers'
require 'fluent/pipeline/errors'

module Fluent
  class Pipeline
    include Fluent::Helpers

    def self.dispatch(passable)
      new(passable)
    end

    def through(pipes)
      self.pipes.push(*pipes)
      self
    end

    def via(method_name)
      self.pipe_method = method_name
      self
    end

    def then(callback = nil)
      handle_pipes
      return passable unless callback

      callback.call(passable)
    end

    private

    attr_accessor :passable, :pipe_method
    attr_reader :pipes

    def initialize(passable)
      @passable = passable
      @pipes = []
    end

    def via_method
      pipe_method || :call
    end

    def handle_pipes
      with_undefined_method_handle do
        pipes.each do |pipe|
          self.passable = pipe.send(via_method, passable)
        end
      end
    end
  end
end
