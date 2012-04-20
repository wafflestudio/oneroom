class User
  include Mongoid::Document

  #=== Fields ===
  field :username, type: String
  field :password, type: String
  field :password_salt, type: String

  field :name, type: String
  field :email, type: String

  #=== Relations ===
  has_many :evaluations
  embeds_one :image

  #=== Validations ===
  attr_accessor :password_confirmation

  validates_presence_of :username
  validates_uniqueness_of	:username
  validates_format_of	:username, :with => /^[a-zA-Z0-9_]{4,20}$/

  validates_presence_of :password
  validates_presence_of :password_confirmation, :on => :create
  validates_confirmation_of :password

  validates_presence_of :name
  validates_presence_of :email

  #=== Functions ===
  private
  def user_before_create
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    salt = Array.new(8) { chars[rand(chars.size-1)] }.to_s
    self.password_salt, self.password = salt, self.password.crypt("$6$#{salt}")
  end

  public
  def self.login username, password
    user = User.where(:username => username).first
    return NOTEXIST if user.nil?
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
end
