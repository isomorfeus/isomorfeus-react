module Isomorfeus
  module Props
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
          cast!
          type!
        end
        run_checks!
        true
      end

      private

      # basic tests

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
            Isomorfeus.raise_error "#{@c}: #{@p} cast failed" unless @v.class == @o[:class]
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
          Isomorfeus.raise_error "#{@c}: #{@p} class not #{@o[:class]}" unless @v.class == @o[:class]
        elsif @o.key?(:is_a)
          Isomorfeus.raise_error "#{@c}: #{@p} is not a #{@o[:is_a]}" unless @v.is_a?(@o[:is_a])
        elsif @o.key?(:type)
          case @o[:type]
          when :boolean
            Isomorfeus.raise_error "#{@c}: #{@p} is not a boolean" unless @v.class == TrueClass || @v.class == FalseClass
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
      end

      # specific validations
      def c_gt(v)
        Isomorfeus.raise_error "#{@c}: #{@p} not greater than #{v}!" unless @v > v
      end

      def c_lt(v)
        Isomorfeus.raise_error "#{@c}: #{@p} not less than #{v}!" unless @v < v
      end

      def c_keys(v)
        Isomorfeus.raise_error "#{@c}: #{@p} keys dont fit!" unless @v.keys.sort == v.sort
      end

      def c_size(v)
        Isomorfeus.raise_error "#{@c}: #{@p} length/size is not #{v}" unless @v.size == v
      end

      def c_matches(v)
        Isomorfeus.raise_error "#{@c}: #{@p} does not match #{v}" unless v.match?(@v)
      end

      def c_max(v)
        Isomorfeus.raise_error "#{@c}: #{@p} is larger than #{v}" unless @v <= v
      end

      def c_min(v)
        Isomorfeus.raise_error "#{@c}: #{@p} is smaller than #{v}" unless @v >= v
      end

      def c_max_size(v)
        Isomorfeus.raise_error "#{@c}: #{@p} is larger than #{v}" unless @v.size <= v
      end

      def c_min_size(v)
        Isomorfeus.raise_error "#{@c}: #{@p} is smaller than #{v}" unless @v.size >= v
      end

      def c_direction(v)
        Isomorfeus.raise_error "#{@c}: #{@p} is positive" if v == :negative && @v >= 0
        Isomorfeus.raise_error "#{@c}: #{@p} is negative" if v == :positive && @v < 0
      end

      def c_test
        Isomorfeus.raise_error "#{@c}: #{@p} test condition check failed" unless @o[:test].call(@v)
      end

      def c_sub_type(v)
        case v
        when :email
        when :url
        end
      end
    end
  end
end
