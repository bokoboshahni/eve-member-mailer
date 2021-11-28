# frozen_string_literal: true

class RenderLiquidTemplate < ApplicationService
  def initialize(template, context)
    super

    @template = Liquid::Template.parse(template)
    @context = context
  end

  def call
    template.render(context)
  end

  private

  attr_reader :template, :context
end
