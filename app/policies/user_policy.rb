# frozen_string_literal: true

# Authorization policy for users.
class UserPolicy < ApplicationPolicy
  # Scope for user authorization policy.
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    admin?
  end

  def show?
    user == record || admin?
  end

  def create?
    admin?
  end

  def new?
    admin?
  end

  def update?
    user == record || admin?
  end

  def edit?
    user == record || admin?
  end

  def discard?
    user == record || admin?
  end

  def destroy?
    user == record || admin?
  end
end
