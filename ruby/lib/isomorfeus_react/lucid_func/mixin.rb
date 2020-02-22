module LucidFunc
  module Mixin
    def self.included(base)
      base.include(::React::Component::Elements)
      base.include(::React::Component::Features)
      base.include(::LucidFunc::Initializer)
      base.include(::React::FunctionComponent::Api)
      base.extend(::Isomorfeus::ExecutionEnvironmentHelpers)
      base.include(::Isomorfeus::ExecutionEnvironmentHelpers)
      base.extend(::LucidFunc::NativeComponentConstructor)
      base.include(::LucidComponent::Api)
    end
  end
end
