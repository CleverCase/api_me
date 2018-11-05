class TestModelPolicy < ApplicationPolicy
  def permitted_attributes
    [:test]
  end
end
