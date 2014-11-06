<% module_namespacing do -%>
class <%= policy_class_name %> < <%= parent_class_name %>
  def permitted_attributes
    [<%= strong_parameters %>]
  end
end
<% end -%>
