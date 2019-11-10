require 'test_helper'

class PrefecturesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get prefectures_show_url
    assert_response :success
  end

end
