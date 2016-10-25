class BucketlistsController < ApplicationController
  before_action :set_bucketlist, only: [:show, :update, :destroy]

  # GET /bucketlists
  def index
    @bucketlists = Bucketlist.all

    render json: @bucketlists
  end

  # GET /bucketlists/1
  def show
    render json: @bucketlist
  end

  # POST /bucketlists
  def create
    @bucketlist = Bucketlist.new(bucketlist_params)

    if @bucketlist.save
      render json: @bucketlist, status: :created, location: @bucketlist
    else
      render json: @bucketlist.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /bucketlists/1
  def update
    if @bucketlist.update(bucketlist_params)
      render json: @bucketlist
    else
      render json: @bucketlist.errors, status: :unprocessable_entity
    end
  end

  # DELETE /bucketlists/1
  def destroy
    @bucketlist.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bucketlist
      @bucketlist = Bucketlist.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bucketlist_params
      params.require(:bucketlist).permit(:name, :user_id)
    end
end
