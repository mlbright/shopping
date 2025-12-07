require "test_helper"

class ShoppingListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @shopping_list = shopping_lists(:one)
    log_in_as @user
  end

  test "should get index" do
    get shopping_lists_path
    assert_response :success
  end

  test "should get show" do
    get shopping_list_path(@shopping_list)
    assert_response :success
  end

  test "should get new" do
    get new_shopping_list_path
    assert_response :success
  end

  test "should create shopping_list" do
    assert_difference("ShoppingList.count", 1) do
      post shopping_lists_path, params: { shopping_list: { name: "New List", household_id: @user.households.first.id } }
    end
    assert_redirected_to shopping_list_path(ShoppingList.last)
  end

  test "should get edit" do
    get edit_shopping_list_path(@shopping_list)
    assert_response :success
  end

  test "should update shopping_list" do
    patch shopping_list_path(@shopping_list), params: { shopping_list: { name: "Updated List" } }
    assert_redirected_to shopping_list_path(@shopping_list)
  end

  test "should destroy shopping_list" do
    assert_difference("ShoppingList.count", -1) do
      delete shopping_list_path(@shopping_list)
    end
    assert_redirected_to shopping_lists_path
  end
end
