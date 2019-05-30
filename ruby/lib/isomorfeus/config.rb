module Isomorfeus
  if RUBY_ENGINE == 'opal'
    class << self
      attr_reader :initialized
      attr_reader :store
      attr_reader :env

      def init
        return if initialized
        @initialized = true
        # at least one reducer must have been added at this stage
        # this happened in isomorfeus-react.rb, where the component reducers were added
        force_init!
      end

      def force_init!
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

      def env=(env_string)
        @env = env_string ? env_string.to_s : 'development'
        @development = (@env == 'development') ? true : false
        @production = (@env == 'production') ? true : false
        @test = (@env == 'test') ? true : false
      end

      def development?
        @development
      end

      def production?
        @production
      end

      def test?
        @test
      end

      def start_app!
        Isomorfeus::TopLevel.mount!
      end

      def force_render
        @render_trigger ||= 1
        @render_trigger += 1
        action = { type: 'APPLICATION_STATE', name: 'render_trigger', value: @render_trigger }
        Isomorfeus.store.dispatch(action)
        @render_trigger
      end
    end

    self.add_client_option(:client_init_class_names, [])
  else
    class << self
      attr_accessor :server_side_rendering
      attr_reader :env

      def configuration(&block)
        block.call(self)
      end

      def env=(env_string)
        @env = env_string ? env_string.to_s : 'development'
        @development = (@env == 'development') ? true : false
        @production = (@env == 'production') ? true : false
        @test = (@env == 'test') ? true : false
      end

      def development?
        @development
      end

      def production?
        @production
      end

      def test?
        @test
      end

      def ssr_contexts
        @ssr_contexts ||= {}
      end

      def version
        Isomorfeus::VERSION
      end
    end
  end
end
