# frozen_string_literal: true

class TestModelPolicy < ApplicationPolicy
  def permitted_attributes
    [:test]
  end
end
