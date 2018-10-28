# class Object
#   alias _react_resolution_original_method_missing method_missing
#
#   def method_missing(component_name, *args, &block)
#     # html tags are defined as methods, so they will not end up here.
#     # first check for native component and render it, we want to be fast for native components
#     # second check for ruby component and render it, they are a bit slower anyway
#     # third pass on method missing
#
#     %x{
#       if (component_name[0] === component_name[0].toUpperCase()) {
#         var component = null;
#         if (typeof Opal.global[component_name] == "function") {
#           component = Opal.global[component_name];
#         }
#         else {
#           try {
#             var constant = self.$const_get(component_name, true);
#             if (typeof constant.react_component == "function") {
#               component = constant.react_component;
#             }
#           }
#           catch(err) {
#             component = null;
#           }
#         }
#         if (component) {
#           var props = null;
#
#           if (args.length > 0) {
#             props = Opal.React.to_native_react_props(#@native, args[0]);
#           }
#           Opal.React.internal_render(component, props, block);
#         } else {
#           return #{_react_resolution_original_method_missing(component_name, *args, block)};
#         }
#       } else {
#         return #{_react_resolution_original_method_missing(component_name, *args, block)};
#       }
#     }
#   end
# end