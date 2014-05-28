class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  def welcome_email(user)
    @user = user
    @url = signin_path
    mail(to: @user.email, subject: "Welcome!")
  end

end
