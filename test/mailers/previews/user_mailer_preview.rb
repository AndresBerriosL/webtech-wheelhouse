
class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first || User.new(
      email_address: "example@wheelhouse.cl"
    )

    UserMailer.welcome(user)
  end
end
