require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should create session" do
    post login_path, params: { email: users(:one).email, password: "password123" }
    assert_redirected_to root_path
  end

  test "should destroy session" do
    log_in_as users(:one)
    delete logout_path
    assert_redirected_to login_path
  end
end
