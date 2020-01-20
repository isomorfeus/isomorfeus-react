module Isomorfeus
  class ThreadLocalCache
    def initialize
      Thread.current[:local_cache] = {} unless Thread.current.key?(:local_cache)
    end

    def [](key)
      Thread.current[:local_cache][key]
    end
    alias fetch []

    def []=(key, value)
      Thread.current[:local_cache][key] = value
    end
    alias store []=

    def key?(key)
      Thread.current[:local_cache].key?(key)
    end
  end
end
