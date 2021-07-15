# frozen_string_literal: true

# Generates slugs.
module SlugConcern
  extend ActiveSupport::Concern

  ID_ALPHABET = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHJKMNPQRSTVWXYZ'

  included do
    before_validation :generate_slug, on: :create
  end

  def generate_slug
    self.slug = Nanoid.generate(alphabet: ID_ALPHABET, size: 8)
  end
end
