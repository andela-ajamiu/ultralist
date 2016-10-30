module Api
  module V1
    class BucketlistsController < ApplicationController
      before_action :authenticate_token_and_user, only: [:index, :create]
      before_action :set_bucketlist, only: [:show, :update, :destroy]

      def index
        @bucketlists = logged_in_user.bucketlists
        if @bucketlists.any?
          search_and_paginate(@bucketlists)
        else
          render json: { message: Message.no_bucketlist }
        end
      end

      def show
        render json: @bucketlist
      end

      def create
        @bucketlist = logged_in_user.bucketlists.new(bucketlist_params)

        if @bucketlist.save
          render json: @bucketlist, status: :created
        else
          render json: { error: @bucketlist.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        return render(json: { error: Message.bucketlist_name },
                      status: :unprocessable_entity) if bucketlist_params.empty?
        if @bucketlist.update(bucketlist_params)
          render json: @bucketlist
        else
          render json: { error: @bucketlist.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @bucketlist.destroy
        render json: { message: Message.bucketlist_deleted }
      end

      private

      def set_bucketlist
        return false unless authenticate_token_and_user
        @bucketlist = logged_in_user.bucketlists.find_by(id: params[:id])
        render json: { error: Message.bucketlist_not_found },
               status: 404 unless @bucketlist
      end

      def search_and_paginate(bucketlists)
        if bucketlists.paginate_and_search(params).any?
          render json: bucketlists.paginate_and_search(params)
        else
          render json: { error: Message.empty_search_result }
        end
      end

      def bucketlist_params
        params.permit(:name)
      end
    end
  end
end
