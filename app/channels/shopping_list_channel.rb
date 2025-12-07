class ShoppingListChannel < ApplicationCable::Channel
  def subscribed
    shopping_list = ShoppingList.find(params[:id])
    stream_from "shopping_list:#{shopping_list.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
