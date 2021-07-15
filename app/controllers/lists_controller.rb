# frozen_string_literal: true

# Controller for lists.
class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_list, only: %i[show edit update destroy]

  def index
    authorize(List)
    @pagy, @lists = pagy(current_corporation.lists.kept.order(:name))
  end

  def new
    @list = authorize(List.new)
  end

  def create
    @list = authorize(current_corporation.lists.build(list_params.merge(condition_quantifier: 'all')))
    if @list.save
      flash[:success] = 'List created successfully.'
      redirect_to list_path(@list)
    else
      render :new
    end
  end

  def show
    @pagy, @list_members = pagy(@list.list_members)
  end

  def edit; end

  def update
    if @list.update(list_params)
      flash[:success] = 'List updated successfully.'
      redirect_to list_path(@list)
    else
      render :edit
    end
  end

  def destroy
    @list.destroy
    flash[:success] = 'List deleted successfully.'
    redirect_to lists_path
  end

  def discard
    @list.discard
    flash[:success] = 'List moved to trash.'
    redirect_to lists_path
  end

  private

  def list_params
    params.require(:list).permit(:name, :description, :kind)
  end

  def find_list
    @list = authorize(current_corporation.lists.kept.find(params[:id]))
  end
end
