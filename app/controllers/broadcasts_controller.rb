# frozen_string_literal: true

# Controller for broadcasts.
class BroadcastsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_broadcast, only: %i[show edit update discard destroy]

  def index
    @pagy, @broadcasts = pagy(authorize(current_corporation.broadcasts.kept))
  end

  def new
    @source_broadcast = Broadcast.find_by(id: new_params[:broadcast_id])
    @broadcast = authorize(current_corporation.broadcasts.build(@source_broadcast&.attributes))
  end

  def create
    @source_broadcast = Broadcast.find_by(id: broadcast_params[:broadcast_id])
    @broadcast = authorize(current_corporation.broadcasts.build(broadcast_params.except(:broadcast_id)))
    @broadcast.copy_from(@source_broadcast) if @source_broadcast
    if @broadcast.save
      flash[:success] = 'Broadcast created successfully.'
      redirect_to broadcast_path(@broadcast)
    else
      render :new
    end
  end

  def show
    case @broadcast.audience
    when 'list'
      @pagy, @recipients = pagy(@broadcast.list.members)
    when 'everyone'
      @pagy, @recipients = pagy(current_corporation.members)
    end
  end

  def edit; end

  def update
    if @broadcast.update(broadcast_params)
      flash[:success] = 'Broadcast updated successfully.'
      redirect_to broadcast_path(@broadcast)
    else
      render :edit
    end
  end

  def discard
    @broadcast.discard
    flash[:success] = 'Broadcast moved to trash successfully.'
    redirect_to broadcasts_path
  end

  def destroy
    @broadcast.destroy
    flash[:success] = 'Broadcast deleted successfully.'
    redirect_to broadcasts_path
  end

  private

  def new_params
    params.permit(:broadcast_id)
  end

  def broadcast_params
    params.require(:broadcast).permit(:name, :subject, :body, :audience, :list_id, :sender_id, :broadcast_id)
  end

  def find_broadcast
    @broadcast = authorize(current_corporation.broadcasts.find(params[:id]))
  end
end
