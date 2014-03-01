class SegmentsController < ApplicationController
  before_action :set_segment, only: [:show, :edit, :update, :destroy]

  # GET /segments
  # GET /segments.json
  def index
    @segments = @user.segments
  end

  # GET /segments/1
  # GET /segments/1.json
  def show
    @contacts = @segment.contacts.includes(:segments).paginate(page: params[:page], per_page: 20)
  end

  # GET /segments/new
  def new
    @segment = Segment.new(conditions: [["", "", ""]])
  end

  # GET /segments/1/edit
  def edit
  end

  # POST /segments
  # POST /segments.json
  def create
    @segment = @user.segments.new(segment_params)

    respond_to do |format|
      if @segment.save
        format.html { redirect_to @segment, notice: 'Segment was successfully created.' }
        format.json { render action: 'show', status: :created, location: @segment }
      else
        format.html { render action: 'new' }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /segments/1
  # PATCH/PUT /segments/1.json
  def update
    respond_to do |format|
      if @segment.update(segment_params)
        format.html { redirect_to @segment, notice: 'Segment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @segment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /segments/1
  # DELETE /segments/1.json
  def destroy
    @segment.destroy
    respond_to do |format|
      format.html { redirect_to segments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_segment
      @segment = @user.segments.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def segment_params
      params.require(:segment).permit(:name, :model).tap do |whitelisted|
        conditions = []
        
        if params[:field]
          params[:field].each_with_index do |field, index|
            condition = [params[:field][index], params[:matcher][index], params[:search][index]]
            condition.push "and" if params[:field].size != index + 1
            conditions.push condition
          end
        end
        
        whitelisted[:conditions] = conditions
      end
    end
end
