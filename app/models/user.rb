#encoding: utf-8
class User
  include Mongoid::Document
  before_create :user_save_password
  #before_update :user_before_create

  #=== Constants
  NOTEXIST = 1
  PASSWORD = 2
  NOTAUTHORIZED = 3

  #=== Fields ===
  field :username, type: String
  field :password, type: String
  field :password_salt, type: String

  field :name, type: String
  field :email, type: String

  field :auth_token, type: String
  field :authorized, type: Boolean, default: false

  #=== Relations ===
  has_many :evaluations
  embeds_one :image

  #=== Validations ===
  attr_accessor :password_confirmation

  validates_presence_of :username, :message => "아이디를 입력해주세요."
  validates_uniqueness_of	:username, :message => "이미 존재하는 아이디입니다."
  validates_format_of	:username, :with => /^[a-zA-Z0-9_]{4,20}$/, :message => "아이디는 영문과 숫자 4~20자만 가능합니다."

  validates_presence_of :password, :message => "비밀번호를 입력해주세요."
  validates_presence_of :password_confirmation, :on => :create, :message => "비밀번호 확인을 입력해주세요."
  validates_confirmation_of :password, :message => "비밀번호와 확인값이 다릅니다."

  validates_presence_of :name, :message => "닉네임을 입력해주세요."
  validates_uniqueness_of :name, :message => "이미 존재하는 닉네임입니다."

  validates_presence_of :email, :message => "이메일을 입력해주세요."
  validates_uniqueness_of :email, :message => "이미 존재하는 이메일입니다."
  validates_format_of :email, :with => /@snu\.ac\.kr$/, :message => "서울대학교 포털 메일 주소가 아닙니다."

  #=== Functions ===

  def user_save_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    salt = Array.new(8) { chars[rand(chars.size-1)] }.join("").to_s
    self.password_salt, self.password = salt, self.password.crypt("$6$#{salt}")
  end


  def self.login username, password
    user = User.where(:username => username).first
    return NOTEXIST if user.nil?
    return NOTAUTHORIZED unless user.authorized
    return PASSWORD if user.password != password.crypt("$6$#{user.password_salt}")
    return user
  end

  def check_password password
    self.password == password.crypt("$6$#{self.password_salt}")
  end

  def self.add_user user_param
    u = User.new(user_param)
    if u.save
      return u
    else
      u.destroy
    end
    nil
  end

  def generate_auth_token
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    self.update_attribute(:auth_token, Array.new(8) { chars[rand(chars.size-1)] }.join("").to_s)
  end
end
