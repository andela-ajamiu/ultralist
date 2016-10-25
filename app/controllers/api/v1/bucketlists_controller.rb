module Api
  module V1
    class BucketlistsController < ApplicationController
      before_action :set_bucketlist, only: [:show, :update, :destroy]
      before_action :authenticate_token_and_user

      def index
        @bucketlists = current_user.bucketlists
        if @bucketlists.any?
          render json: @bucketlists
        else
          render json: { message: "No Bucketlist at the moment" }
        end
      end

      def show
        render json: @bucketlist
      end

      def create
        @bucketlist = Bucketlist.new(bucketlist_params)

        if @bucketlist.save
          render json: @bucketlist,
                 status: :created,
                 location: api_v1_bucketlist_path(@bucketlist)
        else
          render json: @bucketlist.errors.full_messages,
                 status: :unprocessable_entity
        end
      end

      def update
        if @bucketlist.update(bucketlist_params)
          render json: @bucketlist
        else
          render json: @bucketlist.errors, status: :unprocessable_entity
        end
      end

      def destroy
        @bucketlist.destroy
      end

      private

      def set_bucketlist
        @bucketlist = Bucketlist.find_by(id: params[:id])
        if @bucketlist
          true
        else
          render json: { error: "Bucketlist not found" }, status: 404
          false
        end
      end

      def bucketlist_params
        params.require(:bucketlist).permit(:name, :user_id)
      end
    end
  end
end
