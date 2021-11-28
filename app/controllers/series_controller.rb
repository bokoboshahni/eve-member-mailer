# frozen_string_literal: true

class SeriesController < AuthenticatedController
  before_action :find_series, only: %i[show edit update destroy]

  def index
    authorize(Series)
    @pagy, @series = pagy(current_user.accessible_series.kept.order(:name))
  end

  def new
    @series = authorize(Series.new)
  end

  def create
    @series = authorize(current_user.accessible_series.build(series_params.merge(trigger_quantifier: 'any',
                                                                                 status: 'active')))
    if @series.save
      flash[:success] = 'Series created successfully.'
      redirect_to series_path(@series)
    else
      render :new
    end
  end

  def show
    @pagy, @series_members = pagy(@series.series_members)
    @deliveries = @series.deliveries.where(member_id: @series_members.map(&:member_id))
  end

  def edit; end

  def update
    if @series.update(series_params)
      flash[:success] = 'Series updated successfully.'
      redirect_to series_path(@series)
    else
      render :edit
    end
  end

  def destroy
    @series.destroy
    flash[:success] = 'Series deleted successfully.'
    redirect_to series_path
  end

  def discard
    @series.discard
    flash[:success] = 'Series moved to trash.'
    redirect_to series_path
  end

  private

  def series_params
    params.require(:series).permit(:name, :kind, :description, :trigger_quantifier, :delivery_hour, :delivery_minute)
  end

  def find_series
    @series = authorize(current_user.series.find(params[:id]))
  end
end
