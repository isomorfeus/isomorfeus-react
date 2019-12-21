module LucidComponent
  module EnvironmentSupport
    def on_browser?
      Isomorfeus.on_browser?
    end

    def on_ssr?
      Isomorfeus.on_ssr?
    end
  end
end
