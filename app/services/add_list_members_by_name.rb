# frozen_string_literal: true

# Manually adds members to a list by name.
class AddListMembersByName
  attr_reader :names, :successes, :failures, :list, :corporation, :raw_names

  def initialize(list, raw_names)
    @list = list
    @raw_names = raw_names
    @names = raw_names.split("\n").map(&:strip).map { |n| n.remove(/[^a-zA-Z0-9\- ']/) }.reject(&:blank?)
    @corporation = list.corporation
    @successes = []
    @failures = []
  end

  def call # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    return true if names.empty?

    found = names.each_with_object([]) { |n, a| a << corporation.members.find_by(name: n) }.compact
    unless found
      @failures = names
      return false
    end

    @failures = names - found.map(&:name)

    list.transaction do
      found.each do |member|
        next if list.list_members.exists?(member_id: member.id)

        list.list_members.create!(member: member, status: 'active')
        successes << member
      end
    end

    failures.empty?
  end
end
