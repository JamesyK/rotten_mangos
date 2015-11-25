class UserMailer < ActionMailer::Base
  default from: "userdestroy@example.com"

  def destroy_email(user)
    @user = user
    mail(to: @user.email, subject: "Your account has been deleted by an admin")
  end
end
