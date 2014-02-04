class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]

  # GET /contacts
  # GET /contacts.json
  def index
    if params[:segment_id]
      @segment = @user.segments.find params[:segment_id]
      @contacts = @segment.contacts.paginate(page: params[:page], per_page: 20)
    else
      @contacts = @user.contacts_in_segments(params[:segments]).paginate(page: params[:page], per_page: 20)
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = @user.contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Segment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @contact }
      else
        format.html { render action: 'new' }
        format.json { render json: { errors: @contact.errors } }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # def save
  #   key = key = params[:event][:data][:contact][:key]
  #   @contact = Contact.where(key: key, user_id: @user.id).first_or_initialize
  #   @contact.update_attributes data: @contact.data.merge(params[:contact][:data])
  #   
  #   respond_to do |format|
  #     format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
  #     format.json { render action: "show" }
  #   end
  # end
  # 
  # def overwrite
  #   key = key = params[:event][:data][:contact][:key]
  #   @contact = Contact.where(key: key, user_id: @user.id).first_or_initialize
  #   @contact.data = params[:contact][:data]
  #   @contact.save
  #   
  #   respond_to do |format|
  #     format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
  #     format.json { render action: "show" }
  #   end
  # end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = @user.contacts.where(key: params[:id]).first
    end
    
    def contact_params
      params.require(:contact).permit(:key).tap do |whitelisted|
        data = Hash[[params[:data_label], params[:data_content]].transpose]
        whitelisted[:data] = data
      end
    end
end
