module LucidApp
  module Context
    def self.create_application_context
      React.create_context('LucidApplicationContext', Isomorfeus.store)
    end
  end
end
