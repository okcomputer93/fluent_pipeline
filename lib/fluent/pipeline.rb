# frozen_string_literal: true

require 'fluent/pipeline/version'

module Fluent
  class Pipeline
    def self.dispatch(passable)
      new(passable)
    end

    def through(pipes)
      self.pipes = pipes
      self
    end

    def via(method_name)
      self.pipe_method = method_name
      self
    end

    def then(callback)
      handle_pipes
      callback.call(passable)
    end

    private

    attr_accessor :passable, :pipes, :pipe_method

    def initialize(passable)
      @passable = passable
    end

    def via_method
      pipe_method || :call
    end

    def handle_pipes
      if pipes.is_a? Array
        pipes.each do |pipe|
          self.passable = pipe.send(via_method, passable)
        end
      else
        self.passable = pipes.call(passable)
      end
    end
  end
end
