module Api
  module V1
    class ItemsController < ApplicationController
      before_action :set_bucketlist, only: [:create, :index]
      before_action :set_bucketlist_item, only: [:show, :update, :destroy]

      def index
        @items = @bucketlist.items.all
        if @items.any?
          render json: @items
        else
          render json: { message: "This Bucketlist is empty" }
        end
      end

      def show
        render json: @item
      end

      def create
        @item = @bucketlist.items.new(item_params)

        if @item.save
          render json: @item, status: :created
        else
          render json: @item.errors.full_messages, status: :unprocessable_entity
        end
      end

      def update
        if item_params.empty? || item_params[:name] == @item.name
          render json: @item.errors, status: :unprocessable_entity
        else
          @item.update(item_params)
          render json: @item
        end
      end

      def destroy
        @item.destroy
        render json: { message: "Bucketlist Item successfully deleted" }
      end

      private

      def set_bucketlist
        return false unless authenticate_token_and_user
        @bucketlist = logged_in_user.bucketlists.find_by(id: params[:bucketlist_id])
        if @bucketlist
          true
        else
          render json: { error: "Bucketlist not found" },
                 status: :not_found unless @bucketlist
          false
        end
      end

      def set_item
        @item = @bucketlist.items.find_by(id: params[:id])
        render json: { error: "Bucketlist Item not found" },
               status: :not_found unless @item
      end

      def set_bucketlist_item
        set_bucketlist && set_item
      end

      def item_params
        params.permit(:name, :done)
      end
    end
  end
end
