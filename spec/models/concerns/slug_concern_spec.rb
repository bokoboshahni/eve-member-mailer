# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SlugConcern do
  let(:model_class) do
    Class.new(ApplicationRecord) do
      self.table_name = 'users'

      include SlugConcern
    end
  end

  it 'generates a slug before validation on creation' do
    record = model_class.new
    record.validate
    expect(record.slug.length).to eq(8)
  end
end
