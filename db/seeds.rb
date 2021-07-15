# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

unless Rails.env.test?
  ActiveRecord::Base.transaction do # rubocop:disable Metrics/BlockLength
    corp = User.find_by!(eve_character_name: 'Marthy Artis').corporation

    corp.campaigns.destroy_all
    corp.lists.destroy_all
    corp.templates.destroy_all

    list = corp.lists.create!(name: 'New members last 30 days', kind: 'auto', condition_quantifier: 'all')
    list.conditions.create!(kind: 'attribute', subject: 'start_date', position: 100, condition: 'is_a_timestamp_after',
                            value_prefix: 'relative_date', value: '30', value_suffix: 'ago')
    AddNewListMembers.new(list, FindNewListMembers.new(list).call).call

    template1 = corp.templates.create!(name: 'Welcome to Brave Nubs #1', subject: 'Hey, {{ recipient }}. Welcome to the party!', # rubocop:disable Layout/LineLength
                                       body: "Welcome to {{ corporation }}, {{ recipient }}!\n\n- {{ sender }}")
    template2 = corp.templates.create!(name: 'Welcome to Brave Nubs #2', subject: 'Hey, {{ recipient }}. Let\'s mine!',
                                       body: "We're happy you're still here!\n\n- {{ sender }}")
    template3 = corp.templates.create!(name: 'Welcome to Brave Nubs #3', subject: 'Hey, {{ recipient }}. Let\'s loot!',
                                       body: "Are you ready for some ninja looting?!\n\n- {{ sender }}")
    template4 = corp.templates.create!(name: 'Welcome to Brave Nubs #4', subject: 'Hey, {{ recipient }}. Let\'s bash!',
                                       body: "Are you ready for a bash?!\n\n- {{ sender }}")

    campaign = corp.campaigns.create!(name: 'Welcome to Brave Nubs Series', status: 'active', kind: 'conditional',
                                      delivery_hour: 23, delivery_minute: 30, trigger_quantifier: 'all')
    campaign.steps.create!(template_id: template1.id, kind: 'evemail', user_id: corp.users.first.id)
    campaign.steps.create!(kind: 'delay', delay_days: 30, user_id: corp.users.first.id)
    campaign.steps.create!(template_id: template2.id, kind: 'evemail', user_id: corp.users.first.id)
    campaign.steps.create!(kind: 'delay', delay_days: 30, user_id: corp.users.first.id)
    campaign.steps.create!(template_id: template3.id, kind: 'evemail', user_id: corp.users.first.id)
    campaign.steps.create!(kind: 'delay', delay_days: 30, user_id: corp.users.first.id)
    campaign.steps.create!(template_id: template4.id, kind: 'evemail', user_id: corp.users.first.id)
    campaign.triggers.create!(kind: 'list', list_id: list.id, list_qualifier: 'any')
    AddNewCampaignMembers.new(campaign, FindNewCampaignMembers.new(campaign).call).call

    member = campaign.members.find_by!(name: 'Marthy Artis')
    ScheduleCampaignMemberDeliveries.new(campaign, member).call
  end
end
