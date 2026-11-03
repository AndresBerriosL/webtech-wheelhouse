
require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    user = User.new(email_address: "test@example.com")

    mail = UserMailer.welcome(user)

    assert_equal "Welcome to Wheelhouse!", mail.subject
    assert_equal ["test@example.com"], mail.to
    assert_equal ["from@example.com"], mail.from

    assert_includes mail.text_part.body.decoded,
                    "Hello, test@example.com!"
  end
end
