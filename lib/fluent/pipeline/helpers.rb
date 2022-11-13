module Fluent
  module Helpers
    def with_undefined_method_handle
      yield
    rescue NoMethodError => e
      raise Fluent::UndefinedPipeMethod, e.name
    end
  end
end
