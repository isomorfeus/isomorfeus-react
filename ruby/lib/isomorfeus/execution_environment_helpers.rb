module Isomorfeus
  module ExecutionEnvironmentHelpers
    def on_browser?;  Isomorfeus.on_browser?;  end
    def on_ssr?;      Isomorfeus.on_ssr?;      end
    def on_desktop?;  Isomorfeus.on_desktop?;  end
    def on_ios?;      Isomorfeus.on_ios?;      end
    def on_android?;  Isomorfeus.on_android?;  end
    def on_mobile?;   Isomorfeus.on_mobile?;   end
    def on_database?; Isomorfeus.on_database?; end
    def on_server?;   Isomorfeus.on_server?;   end
  end
end
