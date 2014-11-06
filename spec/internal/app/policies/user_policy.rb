class UserPolicy < ApplicationPolicy
  def permitted_attributes
    [:id, :username]
  end

  class Scope < ApplicationPolicy::Scope
  end
end
