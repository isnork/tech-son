require "test_helper"

class ScamCheckControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scam_check_index_url
    assert_response :success
  end

  test "should get create" do
    get scam_check_create_url
    assert_response :success
  end
end
