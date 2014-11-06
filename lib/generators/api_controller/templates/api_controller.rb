<% module_namespacing do -%>
class <%= controller_class_name %> < <%= parent_class_name %>
  include ApiMe
  
  #Override default logic here
end
<% end -%>
