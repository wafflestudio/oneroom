#encoding: utf-8
class AuthMailer < ActionMailer::Base
  default from: "oneroom@wafflestudio.com"

  def send_auth_token(user)
    @user = user
    mail(to: @user.email, subject: "[스누ZIP] 서울대학교 학생 인증 메일")
  end
end
