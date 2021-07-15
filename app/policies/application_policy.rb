# frozen_string_literal: true

# Application authorization policy.
class ApplicationPolicy
  # Scope for application authorization policy.
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def new?
    true
  end

  def update?
    true
  end

  def edit?
    true
  end

  def discard?
    true
  end

  def destroy?
    true
  end

  protected

  def admin?
    user.admin?
  end
end
