<% module_namespacing do -%>
class <%= filter_class_name %> < <%= parent_class_name %>
  include ::SearchObject.module #required
  
  # Add custom filter logic here
  # Ex:
  #   option(:search) { |scope, value| scope.where("username LIKE ?", "%#{value}%") }
end
<% end -%>
