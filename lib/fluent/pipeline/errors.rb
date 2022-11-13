module Fluent
  class UndefinedPipeMethod < StandardError
    MESSAGE_LAYOUT = 'Undefined method `%{method_name}` for pipe'

    def initialize(method_name)
      @method_name = method_name
      super(message)
    end

    def message
      format(MESSAGE_LAYOUT, method_name: method_name)
    end

    private

    attr_reader :method_name
  end
end
