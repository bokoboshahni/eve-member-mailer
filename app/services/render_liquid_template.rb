# frozen_string_literal: true

# Renders a liquid template with the given context.
class RenderLiquidTemplate
  def initialize(template, context)
    @template = Liquid::Template.parse(template)
    @context = context
  end

  def call
    template.render(context)
  end

  private

  attr_reader :template, :context
end
