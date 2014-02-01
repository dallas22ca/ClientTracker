class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_contact

  # GET /events
  # GET /events.json
  def index
    if @contact
      @events = @contact.events.includes(:contact)
    else
      @events = @user.events.includes(:contact)
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # POST /events
  # POST /events.json
  def create
    key = params[:event][:data].delete :key
    @contact = @user.contacts.where(key: key).first_or_create
    @event = @contact.events.new(event_params)
    @event.user = @user

    respond_to do |format|
      if @event.save
        format.html { redirect_to contact_event_url(@contact, @event), notice: 'Event was successfully created.' }
        format.json { render action: 'show', status: :created, location: contact_event_url(@contact, @event) }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = @user.events.find(params[:id])
    end
    
    def set_contact
      @contact = @user.contacts.where(key: params[:contact_id]).first if params[:contact_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:description).tap do |whitelisted|
        whitelisted[:data] = params[:event][:data]
      end
    end
end
