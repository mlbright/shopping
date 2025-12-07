class ShoppingItemsController < ApplicationController
  before_action :set_shopping_list
  before_action :verify_access
  before_action :set_shopping_item, only: [ :update, :destroy, :toggle_completed, :defer, :update_position ]

  def create
    @shopping_item = @shopping_list.shopping_items.build(shopping_item_params)

    if @shopping_item.save
      respond_to do |format|
        format.html { redirect_to @shopping_list }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @shopping_list, alert: "Failed to create item." }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_item_form", partial: "shopping_items/form", locals: { shopping_list: @shopping_list, shopping_item: @shopping_item }) }
      end
    end
  end

  def update
    if @shopping_item.update(shopping_item_params)
      respond_to do |format|
        format.html { redirect_to @shopping_list }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to @shopping_list, alert: "Failed to update item." }
        format.turbo_stream
      end
    end
  end

  def destroy
    @shopping_item.destroy
    respond_to do |format|
      format.html { redirect_to @shopping_list, notice: "Item deleted." }
      format.turbo_stream
    end
  end

  def toggle_completed
    new_state = @shopping_item.completed? ? "active" : "completed"
    @shopping_item.update(state: new_state)

    respond_to do |format|
      format.html { redirect_to @shopping_list }
      format.turbo_stream
    end
  end

  def defer
    @shopping_item.update(state: "deferred")

    respond_to do |format|
      format.html { redirect_to @shopping_list }
      format.turbo_stream
    end
  end

  def update_position
    @shopping_item.update(position: params[:position])

    respond_to do |format|
      format.html { redirect_to @shopping_list }
      format.turbo_stream
    end
  end

  private

  def set_shopping_list
    @shopping_list = ShoppingList.find(params[:shopping_list_id])
  end

  def verify_access
    unless current_user.households.include?(@shopping_list.household)
      redirect_to root_path, alert: "You don't have access to that shopping list."
    end
  end

  def set_shopping_item
    @shopping_item = @shopping_list.shopping_items.find(params[:id])
  end

  def shopping_item_params
    params.require(:shopping_item).permit(:name, :state, :position)
  end
end
