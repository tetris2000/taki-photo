require 'test_helper'

class PostCommentsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get post_comments_create_url
    assert_response :success
  end

  test "should get edit" do
    get post_comments_edit_url
    assert_response :success
  end

  test "should get update" do
    get post_comments_update_url
    assert_response :success
  end

  test "should get destroy" do
    get post_comments_destroy_url
    assert_response :success
  end

end
