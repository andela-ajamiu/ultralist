module Api
  module V1
    class BucketlistsController < ApplicationController
      before_action :authenticate_token_and_user, only: [:index, :create]
      before_action :set_bucketlist, only: [:show, :update, :destroy]

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
        @bucketlist = current_user.bucketlists.new(bucketlist_params)

        if @bucketlist.save
          render json: @bucketlist, status: :created
        else
          render json: { error: @bucketlist.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if bucketlist_params.empty? || bucketlist_params[:name] == @bucketlist.name
          render json: { error: "Please input a new name for the bucketlist" },
                 status: :unprocessable_entity
        else
          @bucketlist.update(bucketlist_params)
          render json: @bucketlist
        end
      end

      def destroy
        @bucketlist.destroy
        render json: { message: "Bucketlist successfully deleted" }
      end

      private

      def set_bucketlist
        return false unless authenticate_token_and_user
        @bucketlist = current_user.bucketlists.find_by(id: params[:id])
        render json: { error: "Bucketlist not found" },
               status: 404 unless @bucketlist
      end

      def bucketlist_params
        params.permit(:name)
      end
    end
  end
end
