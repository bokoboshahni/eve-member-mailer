# frozen_string_literal: true

# Controller for broadcast scheduling.
class BroadcastSchedulingController < ApplicationController
  before_action :authenticate_user!
  before_action :find_broadcast
  before_action -> { set_current(:broadcasts) }

  def new
    if @broadcast.subject.blank? || @broadcast.body.blank?
      flash[:error] = 'Broadcast cannot be scheduled until content is completed.'
      redirect_to broadcast_path(@broadcast)
    end

    if %w[delivering delivered].include?(@broadcast.status)
      flash[:error] = 'Broadcast cannot be scheduled once delivery has begun.'
    end

    @broadcast.scheduled_at = Time.zone.now
  end

  def create # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if @broadcast.subject.blank? || @broadcast.body.blank?
      flash[:error] = 'Broadcast cannot be scheduled until content is completed.'
      redirect_to broadcast_path(@broadcast)
    end

    if %w[delivering delivered].include?(@broadcast.status)
      flash[:error] = 'Broadcast cannot be scheduled once delivery has begun.'
    end

    if @broadcast.update(broadcast_params.merge(status: 'scheduling'))
      ScheduleBroadcastDeliveriesWorker.perform_async(@broadcast.id)
      flash[:success] = 'Broadcast scheduled successfully.'
      redirect_to broadcast_path(@broadcast)
    else
      flash[:error] = 'Error scheduling broadcast.'
      render :new
    end
  end

  private

  def broadcast_params
    params.require(:broadcast).permit(:scheduled_at)
  end

  def find_broadcast
    @broadcast = authorize(current_corporation.broadcasts.find(params[:broadcast_id]))
  end
end
