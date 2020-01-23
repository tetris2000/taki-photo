require 'test_helper'

class AbilityControllerTest < ActionDispatch::IntegrationTest
  test "should get admin" do
    get ability_admin_url
    assert_response :success
  end

end
