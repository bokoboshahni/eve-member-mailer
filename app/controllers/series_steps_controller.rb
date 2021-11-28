# frozen_string_literal: true

class SerieStepsController < AuthenticatedController
  before_action :authenticate_user!
  before_action :find_series
  before_action :find_step, except: %i[new create]
  before_action -> { set_current(:series) }

  def index
    authorize(Series)
    @steps = @series.steps.order(:position)
  end

  def new
    @step = authorize(@series.steps.build)
  end

  def create
    @step = @series.steps.build(step_params)
    if @step.save
      ScheduleSeriesDeliveriesJob.perform_later(@series.id)
      flash[:success] = 'Series step created successfully.'
      redirect_to series_path(@series)
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if params[:series_step] && %w[down up].include?(params[:series_step][:direction])
      authorize(@step, :update?)
      RearrangeSeriesteps.new(@series, @step, params[:series_step][:direction]).call
      ScheduleSeriesDeliveriesJob.perform_later(@series.id)
      flash[:success] = 'Series steps reordered successfully.'
      redirect_to series_path(@series)
    elsif authorize(@step.update(step_params))
      ScheduleSeriesDeliveriesJob.perform_later(@series.id)
      flash[:success] = 'Series step updated successfully.'
      redirect_to series_path(@series)
    else
      render :edit
    end
  end

  def destroy
    authorize(@step.destroy)
    flash[:success] = 'Series step deleted successfully.'
    redirect_to series_path(@series)
  end

  private

  def step_params
    params.require(:series_step).permit(:delay_days, :kind, :template_id, :user_id, :direction)
  end

  def find_series
    @series = authorize(current_user.series.find(params[:series_id]))
  end

  def find_step
    @step = authorize(@series.steps.find(params[:id]))
  end
end
