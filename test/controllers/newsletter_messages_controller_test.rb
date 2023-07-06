require "test_helper"

class NewsletterMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get newsletter_messages_edit_url
    assert_response :success
  end

  test "should get update" do
    get newsletter_messages_update_url
    assert_response :success
  end
end
