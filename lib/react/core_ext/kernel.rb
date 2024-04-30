# backtick_javascript: true

module Kernel
  if RUBY_ENGINE == 'opal'
    def on_browser?; true; end
    def on_server?; false; end

    def after(time_ms, &block)
      `setTimeout(block, time_ms)`
    end
  else
    def on_browser?; false; end
    def on_server?;  true;  end

    def after(time_ms, &block)
      sleep time_ms/1000
      block.call
    end
  end
end
