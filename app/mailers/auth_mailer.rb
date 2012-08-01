#coding:utf-8
class AuthMailer < ActionMailer::Base
  default from: "oneroom@wafflestudio.com"

  def send_auth_token(user)
    @user = user
    mail(to: @user.email, subject: "원룸(oneroom) 서울대학교 학생 확인메일")
  end
end
