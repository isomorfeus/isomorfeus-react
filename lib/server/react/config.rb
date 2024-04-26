module React
  if RUBY_ENGINE == 'opal'
    class << self
      attr_accessor :current_user_sid
      attr_accessor :initial_state_fetched
      attr_accessor :top_component
      attr_accessor :ssr_response_status
      attr_reader :initialized
      attr_reader :env

      def init
        return if initialized
        @initialized = true
        execute_init_classes
      end

      def force_init!
        execute_init_classes
      end

      def add_client_init_class_name(init_class_name)
        client_init_class_names << init_class_name
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

      def start_app!
        React::TopLevel.mount!
      end

      def force_render
        begin
          if React.top_component
            ReactDOM.find_dom_node(React.top_component) if on_browser? || on_desktop? # if not mounted will raise
            if `typeof Opal.global.deepForceUpdate === 'undefined'`
              React.top_component.JS.forceUpdate()
            else
              `Opal.global.deepForceUpdate(#{React.top_component})`
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
  else
    class << self
      attr_accessor :server_side_rendering

      def configuration(&block)
        block.call(self)
      end

      def ssr_contexts
        @ssr_contexts ||= {}
      end

      def version
        React::VERSION
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
      error = error_class.new(message)
      error.set_backtrace(stack) if stack
      raise error
    end
  end
end
