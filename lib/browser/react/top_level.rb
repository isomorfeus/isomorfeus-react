module React
  class TopLevel
    class << self
      def mount!
        React.init
        React::TopLevel.on_ready do
          root_element = `document.querySelector('div[data-iso-root]')`
          React.raise_error(message: "React root element not found!") unless root_element
          component_name = root_element.JS.getAttribute('data-iso-root')
          component = nil
          begin
            component = component_name.constantize
          rescue Exception => e
            `console.warn("Deferring mount: " + #{e.message})`
            @timeout_start = Time.now unless @timeout_start
            if (Time.now - @timeout_start) < 10
              `setTimeout(Opal.React.TopLevel['$mount!'], 100)`
            else
              `console.error("Unable to mount '" + #{component_name} + "'!")`
            end
          end
          if component
            props_json = root_element.JS.getAttribute('data-iso-props')
            props = `Opal.Hash.$new(JSON.parse(props_json))`
            raw_hydrated = root_element.JS.getAttribute('data-iso-hydrated')
            hydrated = (raw_hydrated && raw_hydrated == "true")
            begin
              result = React::TopLevel.mount_component(component, props, root_element, hydrated)
              @tried_another_time = false
              result
            rescue Exception => e
              if  !@tried_another_time
                @tried_another_time = true
                `console.warn("Deferring mount: " + #{e.message})`
                `setTimeout(Opal.React.TopLevel['$mount!'], 250)`
              else
                `console.error("Unable to mount '" + #{component_name} + "'! Error: " + #{e.message} + "!")`
                `console.error(#{e.backtrace.join("\n")})`
             end
            end
          end
        end
      end

      def on_ready(&block)
        %x{
          function run() { block.$call() };
          function ready_fun(fn) {
            if (document.readyState === "complete" || document.readyState === "interactive") {
              setTimeout(fn, 1);
            } else {
              document.addEventListener("DOMContentLoaded", fn);
            }
          }
          ready_fun(run);
        }
      end

      def on_ready_mount(component, props = nil, element_query = nil)
        # init in case it hasn't been run yet
        React.init
        on_ready do
          React::TopLevel.mount_component(component, props, element_query)
        end
      end

      def mount_component(component, props, element_or_query, hydrated = false)
        if `(typeof element_or_query === 'string')` || (`(typeof element_or_query.$class === 'function')` && element_or_query.class == String)
          element = `document.body.querySelector(element_or_query)`
        elsif `(typeof element_or_query.$is_a === 'function')` && element_or_query.is_a?(Browser::Element)
          element = element_or_query.to_n
        else
          element = element_or_query
        end

        top = if hydrated
                React::DOM.hydrate(React.create_element(component, props), element)
              else
                React::DOM.render(React.create_element(component, props), element)
              end
        React.top_component = top if top
      end
    end
  end
end
