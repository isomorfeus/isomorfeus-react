module Isomorfeus
  if RUBY_ENGINE == 'opal'
    class << self
      attr_accessor :current_user_sid
      attr_accessor :initial_state_fetched
      attr_accessor :top_component
      attr_accessor :ssr_response_status
      attr_reader :initialized
      attr_reader :env
      attr_accessor :zeitwerk

      def init
        return if initialized
        @initialized = true
        Isomorfeus.init_store
        execute_init_classes
      end

      def force_init!
        unless Isomorfeus.initial_state_fetched
          Isomorfeus.initial_state_fetched = true
          Redux::Store.preloaded_state = Isomorfeus.store.get_state
        end
        Isomorfeus.force_init_store!
        execute_init_classes
      end

      def add_client_init_class_name(init_class_name)
        client_init_class_names << init_class_name
      end

      def add_client_init_after_store_class_name(init_class_name)
        client_init_after_store_class_names << init_class_name
      end

      def add_client_option(key, value = nil)
        self.class.attr_accessor(key)
        self.send("#{key}=", value)
      end

      # only used for SSR
      def cached_component_classes
        @cached_component_classes ||= {}
      end

      # only used for SSR
      def cached_component_class(class_name)
        return cached_component_classes[class_name] if cached_component_classes.key?(class_name)
        cached_component_classes[class_name] = "::#{class_name}".constantize
      end

      def execute_init_classes
        client_init_class_names.each do |constant|
          constant.constantize.send(:init)
        end
      end

      def execute_init_after_store_classes
        client_init_after_store_class_names.each do |constant|
          constant.constantize.send(:init)
        end
      end

      def env=(env_string)
        @env = env_string ? env_string : 'development'
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
        Isomorfeus.zeitwerk.setup
        Isomorfeus::TopLevel.mount!
      end

      def force_render
        begin
          if Isomorfeus.top_component
            ReactDOM.find_dom_node(Isomorfeus.top_component) if on_browser? || on_desktop? # if not mounted will raise
            if `typeof Opal.global.deepForceUpdate === 'undefined'`
              Isomorfeus.top_component.JS.forceUpdate()
            else
              `Opal.global.deepForceUpdate(#{Isomorfeus.top_component})`
            end
          end
        rescue Exception => e
          # TODO try mount first
          # if it fails
          `console.error("force_render failed'! Error: " + #{e.message} + "! Reloading page.")`
          `location.reload()` if on_browser?
        end
        nil
      end
    end

    self.add_client_option(:client_init_class_names, [])
    self.add_client_option(:client_init_after_store_class_names, [])
  else
    class << self
      attr_reader :component_cache_init_block
      attr_accessor :server_side_rendering
      attr_accessor :ssr_hot_asset_url
      attr_reader :env
      attr_accessor :zeitwerk
      attr_accessor :zeitwerk_lock

      def component_cache_init(&block)
        @component_cache_init_block = block
      end

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

      def load_configuration(directory)
        Dir.glob(File.join(directory, '*.rb')).sort.each do |file|
          require File.expand_path(file)
        end
      end
    end
  end

  class << self
    def raise_error(error_class: nil, message: nil, stack: nil)
      error_class = RuntimeError unless error_class
      execution_environment = if on_browser? then 'on Browser'
                              elsif on_ssr? then 'in Server Side Rendering'
                              elsif on_server? then 'on Server'
                              elsif on_mobile? then 'on Mobile'
                              elsif on_database? then 'on Database'
                              else
                                'on Client'
                              end
      error = error_class.new("Isomorfeus in #{env} #{execution_environment}:\n#{message}")
      error.set_backtrace(stack) if stack

      if Isomorfeus.development?
        if RUBY_ENGINE == 'opal'
          ecn = error_class ? error_class.name : ''
          m = message ? message : ''
          s = stack ? stack : ''
          `console.error(ecn, m, s)`
        else
          STDERR.puts "#{ecn}: #{m}\n #{s}"
        end
      end
      raise error
    end
  end
end
