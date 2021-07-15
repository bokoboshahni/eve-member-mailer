# frozen_string_literal: true

# Authorization policy for user characters.
class UserCharacterPolicy < ApplicationPolicy
  # Authorization policy scope for user characters.
  class Scope < Scope
    def resolve
      scope.where(user_id: user.id)
    end
  end

  def index?
    true
  end

  def show?
    user == record.user || admin?
  end

  def create?
    admin?
  end

  def new?
    admin?
  end

  def update?
    user == record.user || admin?
  end

  def edit?
    user == record.user || admin?
  end

  def discard?
    user == record.user || admin?
  end

  def destroy?
    user == record.user || admin?
  end
end
