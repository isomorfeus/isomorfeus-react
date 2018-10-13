if RUBY_ENGINE == 'opal'
  module Isomorfeus
    class << self
      attr_reader :options
      attr_reader :initialized
      attr_reader :store

      def init
        return if initialized
        @initialized = true
        # at least one reducer must have be added at this stage
        # this happened in isomorfeus-react.rb, where the component reducer was added
        @store = Redux::Store.init!
        `Opal.Isomorfeus.store = #@store`
        init_options
        execute_init_classes
      end

      def init_options
        return @options if @options
        @options = Hash.new(`Opal.IsomorfeusOptions`)
        @options.keys.each do |option|
          define_singleton_method(option) do
            @options[option]
          end
        end
      end

      def execute_init_classes
        if options.has_key?(:client_init_class_names)
          client_init_class_names.each do |constant|
            constant.constantize.send(:init)
          end
        end
      end
    end
  end
else
  module Isomorfeus
    class << self
      attr_accessor :client_init_class_names
      attr_accessor :prerendering
      attr_accessor :version

      def add_client_option(option)
        @options_for_client ||= Set.new
        @options_for_client << option
      end

      def add_client_options(options)
        options.each do |option|
          add_client_option(option)
        end
      end

      def add_client_init_class_name(class_name)
        client_init_class_names << class_name
      end

      def configuration(&block)
        block.call(self)
      end

      def options_for_client
        @options_for_client
      end

      def options_hash_for_client
        opts = {}
        Isomorfeus.options_for_client.each do |option|
          opts[option] = Isomorfeus.send(option)
        end
        opts
      end
    end

    self.add_client_option(:client_init_class_names)
    self.add_client_option(:version)

    self.client_init_class_names = []
    self.prerendering = :off
    # self.version = ::Isomorfeus::Component::VERSION # thats equal to the isomorfeus version
  end
end
