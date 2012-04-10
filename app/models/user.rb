class User
  include Mongoid::Document

  #=== Fields ===
  field :name, type: String

  #=== Relations ===
  has_many :evaluations
  embeds_one :image
end
