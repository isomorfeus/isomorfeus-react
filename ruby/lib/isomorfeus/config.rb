module Isomorfeus
  if RUBY_ENGINE == 'opal'
    class << self
      attr_reader :initialized?
      attr_reader :store

      def init
        return if initialized?
        @initialized = true
        # at least one reducer must have been added at this stage
        # this happened in isomorfeus-react.rb, where the component reducers were added
        @store = Redux::Store.init!
        `Opal.Isomorfeus.store = #@store`
        execute_init_classes
      end

      def add_client_init_class_name(init_class_name)
        client_init_class_names << init_class_name
      end

      def add_client_option(key, value = nil)
        self.class.attr_accessor(key)
        self.send("#{key}=", value)
      end

      def execute_init_classes
        client_init_class_names.each do |constant|
          constant.constantize.send(:init)
        end
      end
    end
    self.add_client_option(:client_init_class_names, [])
  else
    class << self
      attr_accessor :prerendering

      def configuration(&block)
        block.call(self)
      end

      def version
        Isomorfeus::VERSION
      end
    end

    self.prerendering = :off
  end
end
