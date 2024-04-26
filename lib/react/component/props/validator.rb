module React
  class Component
    class Props
      class Validator
        def initialize(source_class, prop, value, options)
          @c = source_class
          @p = prop
          @v = value
          @o = options
        end

        def validate!
          ensured = ensure!
          unless ensured
            set_default_value
            cast!
            type!
          end
          run_checks!
          true
        end

        def validated_value
          validate!
          @v
        end

        private

        # basic tests

        def set_default_value
          return unless @v.nil?
          @v = @o[:default] if @o.key?(:default)
        end

        def cast!
          if @o.key?(:cast)
            begin
              @v = case @o[:class]
                  when Integer then @v.to_i
                  when String then @v.to_s
                  when Float then @v.to_f
                  when Array then @v.to_a
                  when Hash then @v.to_h
                  end
              @v = !!@v if @o[:type] == :boolean
            rescue
              React.raise_error(message: "#{@c}: #{@p} cast failed") unless @v.class == @o[:class]
            end
          end
        end

        def ensure!
          if @o.key?(:ensure)
            @v = @o[:ensure] unless @v
            true
          elsif @o.key?(:ensure_block)
            @v = @o[:ensure_block].call(@v)
            true
          else
            false
          end
        end

        def type!
          return if @o[:allow_nil] && @v.nil?
          if @o.key?(:class)
            React.raise_error(message: "#{@c}: #{@p} class not #{@o[:class]}") unless @v.class == @o[:class]
          elsif @o.key?(:is_a)
            React.raise_error(message: "#{@c}: #{@p} is not a #{@o[:is_a]}") unless @v.is_a?(@o[:is_a])
          elsif @o.key?(:type)
            case @o[:type]
            when :boolean
              React.raise_error(message: "#{@c}: #{@p} is not a boolean") unless @v.class == TrueClass || @v.class == FalseClass
            else
              c_string_sub_types
            end
          end
        end

        # all other checks

        def run_checks!
          if @o.key?(:validate)
            @o[:validate].each do |m, l|
              send('c_' + m, l)
            end
          end
          @o[:validate_block].call(@v) if @o.key?(:validate_block)
        end

        # specific validations
        def c_gt(v)
          React.raise_error(message: "#{@c}: #{@p} not greater than #{v}!") unless @v > v
        end

        def c_lt(v)
          React.raise_error(message: "#{@c}: #{@p} not less than #{v}!") unless @v < v
        end

        def c_keys(v)
          React.raise_error(message: "#{@c}: #{@p} keys dont fit!") unless @v.keys.sort == v.sort
        end

        def c_size(v)
          React.raise_error(message: "#{@c}: #{@p} length/size is not #{v}") unless @v.size == v
        end

        def c_matches(v)
          React.raise_error(message: "#{@c}: #{@p} does not match #{v}") unless v.match?(@v)
        end

        def c_max(v)
          React.raise_error(message: "#{@c}: #{@p} is larger than #{v}") unless @v <= v
        end

        def c_min(v)
          React.raise_error(message: "#{@c}: #{@p} is smaller than #{v}") unless @v >= v
        end

        def c_max_size(v)
          React.raise_error(message: "#{@c}: #{@p} is larger than #{v}") unless @v.size <= v
        end

        def c_min_size(v)
          React.raise_error(message: "#{@c}: #{@p} is smaller than #{v}") unless @v.size >= v
        end

        def c_direction(v)
          React.raise_error(message: "#{@c}: #{@p} is positive") if v == :negative && @v >= 0
          React.raise_error(message: "#{@c}: #{@p} is negative") if v == :positive && @v < 0
        end

        def c_test
          React.raise_error(message: "#{@c}: #{@p} test condition check failed") unless @o[:test].call(@v)
        end

        def c_string_sub_types
          React.raise_error(message: "#{@c}: #{@p} must be a String") unless @v.class == String
          case @o[:type]
          when :email
            React.raise_error(message: "#{@c}: #{@p} is not a valid email address") unless @v.match?(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
          when :uri
            if RUBY_ENGINE == 'opal'
              %x{
                try {
                  new URL(#@v);
                } catch {
                  #{React.raise_error(message: "#{@c}: #{@p} is not a valid uri")}
                }
              }
            else
              React.raise_error(message: "#{@c}: #{@p} is not a valid uri") unless @v.match?(/\A#{URI.regexp}\z/)
            end
          end
        end
      end
    end
  end
end
