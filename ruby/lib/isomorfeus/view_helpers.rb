module Isomorfeus
  module ViewHelpers
    def react_component(component_name, params)
      component_name_id = component_id_name(component_name)
      tag = <<~SCRIPT
        <div id="#{component_name_id}"></div>
        <script type="text/javascript">
          var component = Opal.Object.$const_get("#{component_name}");
          var json_params = #{Oj.dump(params, mode: :compat)};
          Opal.Isomorfeus.$const_get('TopLevel').$mount(component, Opal.Hash.$new(json_params), "##{component_name_id}" );
        </script>
      SCRIPT
      tag.respond_to?(:html_safe) ? tag.html_safe : tag
    end

    private

    def component_id_name(component_name)
      "#{component_name.underscore}_#{Random.rand.to_s[2..-1]}"
    end
  end
end