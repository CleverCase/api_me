class UserPolicy < ApplicationPolicy
  def permitted_attributes
    %i[id username]
  end

  class Scope < ApplicationPolicy::Scope
  end
end
