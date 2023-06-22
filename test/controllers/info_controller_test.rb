require 'test_helper'

class InfoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get info_index_url
    assert_response :success
  end

  test "should get reports" do
    get info_reports_url
    assert_response :success
  end

  test "should get help" do
    get info_help_url
    assert_response :success
  end

end
