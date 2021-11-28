# frozen_string_literal: true

class SeriesSubscriberPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
