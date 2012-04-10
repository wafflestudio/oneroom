class Room
  include Mongoid::Document

  #=== Fields ===
  field :name, type: String
  field :lat, type: String
  field :lng, type: String

  field :address, type: String
  field :phone, type: String
  field :description, type: String

  #=== Relations ===
  has_many :evaluations
  embeds_many :images
end
