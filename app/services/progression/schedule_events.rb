class Progression < ApplicationRecord
  class ScheduleEvents < ApplicationService
    def initialize(progression:)
      super

      @progression = progression
    end

    def call
      steps do |step|
        event = events.where(step: step).first_or_create!(status: step.status)
      end

      events.each do |event|
        if event.first?
          event.update!(scheduled_for: progression.start_date)
        else
          event.update!(scheduled_for: progression.start_date + events.where(kind: 'delay').higher_items.sum(:delay).days)
        end
      end
    end

    private

    attr_reader :progression

    delegate :character, to: :progression
    delegate :events, to: :progression
    delegate :series, to: :progression
    delegate :steps, to: :series
  end
end
