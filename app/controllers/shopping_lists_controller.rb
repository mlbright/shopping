class ShoppingListsController < ApplicationController
  before_action :set_shopping_list, only: [ :show, :edit, :update, :destroy, :clone, :merge ]
  before_action :verify_access, only: [ :show, :edit, :update, :destroy, :clone, :merge ]

  def index
    # Get all shopping lists from all user's households, sorted by most recently updated
    @shopping_lists = current_user.households
                                  .includes(shopping_lists: [ :shopping_items, :creator ])
                                  .flat_map(&:shopping_lists)
                                  .sort_by(&:updated_at)
                                  .reverse
    @households = current_user.households
  end

  def show
    @shopping_items = @shopping_list.shopping_items.order(position: :asc)
  end

  def new
    @shopping_list = ShoppingList.new
    @households = current_user.households
  end

  def create
    household = current_user.households.find(params[:shopping_list][:household_id])
    @shopping_list = household.shopping_lists.build(shopping_list_params)
    @shopping_list.creator = current_user

    if @shopping_list.save
      redirect_to @shopping_list, notice: "Shopping list created successfully!"
    else
      @households = current_user.households
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @households = current_user.households
  end

  def update
    if @shopping_list.update(shopping_list_params)
      redirect_to @shopping_list, notice: "Shopping list updated successfully!"
    else
      @households = current_user.households
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @shopping_list.destroy
    redirect_to shopping_lists_path, notice: "Shopping list deleted successfully!"
  end

  # Clone a shopping list with all or only deferred items
  def clone
    include_completed = params[:include_completed] == "true"

    new_list = @shopping_list.household.shopping_lists.create!(
      name: "#{@shopping_list.name} (Copy)",
      creator: current_user
    )

    items_to_clone = if include_completed
      @shopping_list.shopping_items
    else
      @shopping_list.shopping_items.where.not(state: "completed")
    end

    items_to_clone.each do |item|
      new_list.shopping_items.create!(
        name: item.name,
        state: item.state == "completed" ? "active" : item.state,
        position: item.position
      )
    end

    redirect_to new_list, notice: "Shopping list cloned successfully!"
  end

  # Merge another shopping list into this one
  def merge
    source_list = ShoppingList.find(params[:source_list_id])

    # Verify user has access to source list
    unless current_user.households.include?(source_list.household)
      redirect_to @shopping_list, alert: "You don't have access to that list."
      return
    end

    # Get the highest position in the current list
    max_position = @shopping_list.shopping_items.maximum(:position) || 0

    # Copy all items from source list, keeping duplicates
    source_list.shopping_items.each_with_index do |item, index|
      @shopping_list.shopping_items.create!(
        name: item.name,
        state: item.state,
        position: max_position + index + 1
      )
    end

    redirect_to @shopping_list, notice: "Lists merged successfully!"
  end

  private

  def set_shopping_list
    @shopping_list = ShoppingList.find(params[:id])
  end

  def verify_access
    unless current_user.households.include?(@shopping_list.household)
      redirect_to root_path, alert: "You don't have access to that shopping list."
    end
  end

  def shopping_list_params
    params.require(:shopping_list).permit(:name, :household_id)
  end
end
