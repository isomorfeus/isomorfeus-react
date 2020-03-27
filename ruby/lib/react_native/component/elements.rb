module ReactNative
  module Component
    module Elements
      # https://www.w3.org/TR/html52/fullindex.html#index-elements
      # https://www.w3.org/TR/SVG11/eltindex.html
      UNSUPPORTED_HTML_AND_SVG_ELEMENTS = %w[
        a abbr address area article aside audio
        base bdi bdo blockquote body br
        canvas caption cite col colgroup
        data datalist dd del details dfn dialog dl dt
        em embed
        fieldset figcaption figure footer form
        head header hr html
        iframe ins
        kbd
        label legend li link
        main map mark meta meter
        nav noscript
        object ol optgroup option output
        param picture progress
        q
        rp rt rtc ruby
        s samp script section select small source span strong style sub summary sup
        table tbody td template textarea tfoot th thead time title tr track
        ul
        var video
        wbr

        altGlyph altGlyphDef altGlyphItem animate animateColor animateMotion animateTransform
        color-profile cursor
        desc
        feBlend feColorMatrix feComponentTransfer feComposite feConvolveMatrix feDiffuseLighting
        feDisplacementMap feDistantLight feFlood feFuncA feFuncB feFuncG feFuncR feGaussianBlur
        feImage feMerge feMergeNode feMorphology feOffset fePointLight feSpecularLighting
        feSpotLight feTile feTurbulence
        filter font font-face font-face-format font-face-name font-face-src font-face-uri
        glyph glyphRef
        hkern
        metadata missing-glyph mpath
        script set style switch
        tref
        view vkern
      ]

      UNSUPPORTED_HTML_AND_SVG_ELEMENTS.each do |element|
        define_method(element) do |*args, &block|
          `console.warn("Element " + element + " is not yet supported, using a Text component as substitute!")`
          `Opal.React.internal_prepare_args_and_render(Opal.global.Text, args, block)`
        end
        define_method(`element.toUpperCase()`) do |*args, &block|
          `console.warn("Element " + element + " is not yet supported, using a Text component as substitute!")`
          `Opal.React.internal_prepare_args_and_render(Opal.global.Text, args, block)`
        end
      end

      # button
      %x{
        self['supported_button'] = function(props) {
          let theme = Opal.global.React.useContext(Opal.global.ThemeContext);
          let style = {};
          if (theme && typeof theme['button'] !== 'undefined') { style = theme['button']; }
          if (typeof props.style !== 'undefined') {
            style = Opal.React.merge_deep(style, props.style);
          }
          let new_props = Object.assign({}, props, { style: style });
          if (typeof props.title === 'undefined') {
            try {
              new_props.title = props.children.props.children;
            } catch (e) {
              console.error("BUTTON accepts only one string child!")
            }
          }
          return Opal.global.React.createElement(Opal.global.Button, new_props);
        }
        self['supported_button'].displayName = 'BUTTON';
      }
      define_method('button') do |*args, &block|
        `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements.supported_button, args, block)`
      end
      define_method('BUTTON') do |*args, &block|
        `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements.supported_button, args, block)`
      end

      # img
      define_method('img') do |*args, &block|
        `Opal.React.internal_prepare_args_and_render(Opal.global.Image, args, block)`
      end
      define_method('IMG') do |*args, &block|
        `Opal.React.internal_prepare_args_and_render(Opal.global.Image, args, block)`
      end

      # input
      %x{
        self.supported_input = function(props) {
          Opal.React.render_buffer.push([]);
          if (typeof props.type !== 'undefined') {
            if (props.type === 'text') { return Opal.React.internal_prepare_args_and_render(Opal.global.TextInput, props); }
            else if (props.type === 'checkbox') { return Opal.React.internal_prepare_args_and_render(Opal.global.InputSwitch, props); }
            else {
               console.warn("Input type " + props.type + " not supported. Using TextInput as substitute!");
               return Opal.React.internal_prepare_args_and_render(Opal.global.TextInput, props);
            }
          }
          Opal.React.internal_prepare_args_and_render(Opal.global.TextInput, props);
          return Opal.React.render_buffer.pop();
        }
      }
      define_method('input') do |*args, &block|
        `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements.supported_input, args, block)`
      end
      define_method('INPUT') do |*args, &block|
        `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements.supported_input, args, block)`
      end

      # elements that map to Text with style
      SUPPORTED_TEXT_HTML_ELEMENTS = %w[
        b
        code
        h1 h2 h3 h4 h5 h6
        i
        pre
        span
        u
      ]

      SUPPORTED_TEXT_HTML_ELEMENTS.each do |element|
        fun_name = 'supported_' + element
        %x{
          self[fun_name] = function(props) {
            let theme = Opal.global.React.useContext(Opal.global.ThemeContext);
            let style = {};
            if (theme && typeof theme[element] !== 'undefined') { style = theme[element]; }
            if (typeof props.style !== 'undefined') {
              style = Opal.React.merge_deep(style, props.style);
            }
            let new_props = Object.assign({}, props, { style: style });
            return Opal.global.React.createElement(Opal.global.Text, new_props);
          }
          self[fun_name].displayName = element.toUpperCase();
        }
        define_method(`element.toLowerCase()`) do |*args, &block|
          `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements[fun_name], args, block)`
        end
        define_method(`element.toUpperCase()`) do |*args, &block|
          `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements[fun_name], args, block)`
        end
      end

      SUPPORTED_VIEW_HTML_ELEMENTS = %w[
        div
        p
      ]

      SUPPORTED_VIEW_HTML_ELEMENTS.each do |element|
        fun_name = 'supported_' + element
        %x{
          self[fun_name] = function(props) {
            let theme = Opal.global.React.useContext(Opal.global.ThemeContext);
            let style = {};
            if (theme && typeof theme[element] !== 'undefined') { style = theme[element]; }
            if (typeof props.style !== 'undefined') {
              style = Opal.React.merge_deep(style, props.style);
            }
            let new_props = Object.assign({}, props, { style: style });
            return Opal.global.React.createElement(Opal.global.View, new_props);
          }
          self[fun_name].displayName = element.toUpperCase();
        }
        define_method(`element.toLowerCase()`) do |*args, &block|
          `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements[fun_name], args, block)`
        end
        define_method(`element.toUpperCase()`) do |*args, &block|
          `Opal.React.internal_prepare_args_and_render(Opal.ReactNative.Component.Elements[fun_name], args, block)`
        end
      end
      
      SUPPORTED_SVG_ELEMENTS = %w[
        Circle ClipPath
        Defs
        Ellipse
        ForeignObject
        G
        Image
        Line LinearGradient
        Marker Mask
        Path Pattern Polygon Polyline
        RadialGradient Rect
        Stop Svg Symbol
        Text TextPath TSpan
        Use
      ]

      SUPPORTED_SVG_ELEMENTS.each do |element|
        define_method(`element.toLowerCase()`) do |*args, &block|
          `Opal.React.internal_prepare_args_and_render(Opal.global.ReactNativeSvg[element], args, block)`
        end
        define_method(`element.toUpperCase()`) do |*args, &block|
          `Opal.React.internal_prepare_args_and_render(Opal.global.ReactNativeSvg[element], args, block)`
        end
      end
    end
  end
end
