require "test_helper"

class HouseholdsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @household = households(:one)
    log_in_as @user
  end

  test "should get index" do
    get households_path
    assert_response :success
  end

  test "should get show" do
    get household_path(@household)
    assert_response :success
  end

  test "should get new" do
    get new_household_path
    assert_response :success
  end

  test "should create household" do
    assert_difference("Household.count", 1) do
      post households_path, params: { household: { name: "New Household" } }
    end
    assert_redirected_to household_path(Household.last)
  end

  test "should get edit" do
    get edit_household_path(@household)
    assert_response :success
  end

  test "should update household" do
    patch household_path(@household), params: { household: { name: "Updated Household" } }
    assert_redirected_to household_path(@household)
  end
end
