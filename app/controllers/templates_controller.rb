# frozen_string_literal: true

# Controller for templates.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_template, only: %i[show edit update discard destroy]

  def index
    @pagy, @templates = pagy(authorize(current_corporation.templates.kept))
  end

  def new
    @template = authorize(current_corporation.templates.build)
  end

  def create
    @template = authorize(current_corporation.templates.build(template_params))
    if @template.save
      flash[:success] = 'Template created successfully.'
      redirect_to template_path(@template)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @template.update(template_params)
      flash[:success] = 'Template updated successfully.'
      redirect_to template_path(@template)
    else
      render :edit
    end
  end

  def discard
    if @template.discardable?
      @template.discard
      flash[:success] = 'Template moved to trash successfully.'
      redirect_to templates_path
    else
      flash[:error] = 'Template cannot be moved to trash because it is being used in a campaign.'
      redirect_to template_path(@template)
    end
  end

  def destroy
    @template.destroy
    flash[:success] = 'Template deleted successfully.'
    redirect_to templates_path
  rescue ActiveRecord::DeleteRestrictionError
    flash[:error] = 'Templates cannot be deleted if they have been used in any campaign or delivery.'
    redirect_to template_path(@template)
  end

  private

  def template_params
    params.require(:template).permit(:name, :subject, :body)
  end

  def find_template
    @template = authorize(current_corporation.templates.find(params[:id]))
  end
end
