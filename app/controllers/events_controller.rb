class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_contact
  before_action :set_times, only: [:index]

  # GET /events
  # GET /events.json
  def index
    resource = @contact ? @contact : @user
    
    unless params[:description].blank?
      @events = resource.events.includes(:contact).where(description: params[:description], created_at: @start..@finish).order("events.created_at desc").references(:contact).paginate(page: params[:page], per_page: 20)
    end
    
    @events ||= resource.events.includes(:contact).where(created_at: @start..@finish).references(:contact).order("events.created_at desc").paginate(page: params[:page], per_page: 20)
    
    @all_events = resource.events.where(created_at: @start..@finish)
    @all_events_count = @all_events.count
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end
  
  def edit
  end
  
  def analysis
    
  end

  # POST /events
  # POST /events.json
  def create
    key = params[:event][:contact].delete(:key).parameterize
    @contact = @user.contacts.where(key: key).first_or_create
    @event = @contact.events.new
    @event.created_at = Time.zone.at(params[:event].delete(:remetric_created_at).to_i) if params[:event].has_key? :remetric_created_at
    @event.description = params[:event].delete(:description)
    @event.data = params[:event]
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
  
  # GET /events/img
  def img
    @user = false
    
    begin
      args = JSON.parse(Base64.decode64(params[:args])).to_hash.with_indifferent_access
      @user = User.where(api_key: args.delete(:remetric_api_key)).first
      key = args[:contact].delete(:key).parameterize
      @contact = @user.contacts.where(key: key).first_or_create
      @event = @contact.events.new
      @event.created_at = Time.zone.at(args.delete(:remetric_created_at).to_i) if args.has_key? :remetric_created_at
      @event.description = args.delete(:description)
      @event.data = args
      @event.user = @user
      @event.save
    rescue
    end
    
    if args[:redirect].to_s.blank?
      send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), :type => "image/gif", :disposition => "inline")
    else
      redirect_to args[:redirect]
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
