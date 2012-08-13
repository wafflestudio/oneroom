#encoding: utf-8
class ContactMailer < ActionMailer::Base
  default from: "oneroom@wafflestudio.com"

  def cut_content str
    length = 10
    u = str.unpack('U*')
    u.length > length ? u[0..length-1].pack('U*') + "..." : str
  end

  def send_contact_mail(contact_params)
    @contact = contact_params
    mail(to: "oneroom@wafflestudio.com", subject: "[문의: 스누ZIP] " + cut_content(@contact[:content]))
  end

end
