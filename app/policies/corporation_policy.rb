# frozen_string_literal: true

class CorporationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def show
    user.corporations.pluck(:id).include?(record.id)
  end
end
