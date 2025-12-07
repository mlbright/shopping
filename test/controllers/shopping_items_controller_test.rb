require "test_helper"

class ShoppingItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @shopping_list = shopping_lists(:one)
    @shopping_item = shopping_items(:one)
    log_in_as @user
  end

  test "should create shopping_item" do
    assert_difference("ShoppingItem.count", 1) do
      post shopping_list_shopping_items_path(@shopping_list), params: { shopping_item: { name: "New Item", state: "active" } }
    end
    assert_response :redirect
  end

  test "should update shopping_item" do
    patch shopping_list_shopping_item_path(@shopping_list, @shopping_item), params: { shopping_item: { name: "Updated Item" } }
    assert_response :redirect
  end

  test "should destroy shopping_item" do
    assert_difference("ShoppingItem.count", -1) do
      delete shopping_list_shopping_item_path(@shopping_list, @shopping_item)
    end
    assert_response :redirect
  end
end
