# frozen_string_literal: true

# Adds new members to a list.
class AddNewListMembers < ApplicationService
  def initialize(list, new_members)
    super

    @list = list
    @new_members = new_members
  end

  def call
    new_members.reject! { |m| list.list_members.exists?(member_id: m.id) }
    list.transaction do |_t|
      list.list_members.create!(new_members.map { |m| { member_id: m.id, status: 'active' } })
    end
  end

  private

  attr_reader :list, :new_members
end
