# frozen_string_literal: true

# Controller for list conditions.
class ListConditionsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_list
  before_action :find_condition, except: %i[new create]
  before_action -> { set_current(:lists) }

  def new
    @condition = authorize(@list.conditions.build)
  end

  def create
    @condition = authorize(@list.conditions.build(condition_params.merge(kind: 'attribute')))
    if @condition.save
      flash[:success] = 'List condition created successfully. Discovering new members for list...'
      AddListMembersJob.perform_later(@list.id, true)
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def reorder # rubocop:disable Metrics/AbcSize
    return unless params[:list_condition] && %w[down up].include?(params[:list_condition][:direction])

    RearrangeListConditions.new(@list, @condition, params[:list_condition][:direction]).call
    AddListMembersJob.perform_later(@list.id, true)
    flash[:success] = 'List conditions reordered successfully. Disovering new members for list...'
    redirect_to list_path(@list)
  end

  def update
    if @condition.update(condition_params)
      AddListMembersJob.perform_later(@list.id, true)
      flash[:success] = 'List condition updated successfully. Discovering new members for list...'
      redirect_to list_path(@list)
    else
      render :edit
    end
  end

  def destroy
    @condition.destroy
    flash[:success] = 'List condition deleted successfully.'
    redirect_to list_path(@list)
  end

  private

  def condition_params
    params.require(:list_condition).permit(:subject, :kind, :position, :quantifier, :value, :value_prefix,
                                           :value_suffix, :condition, :direction)
  end

  def find_list
    @list = current_corporation.lists.find(params[:list_id])
  end

  def find_condition
    @condition = authorize(@list.conditions.find(params[:id] || params[:condition_id]))
  end
end
