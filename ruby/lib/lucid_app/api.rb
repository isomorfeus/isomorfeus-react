module LucidApp
  module API
    def self.included(base)
      def context
        @native.JS[:context]
      end
    end
  end
end
