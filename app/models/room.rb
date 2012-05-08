class Room
  include Mongoid::Document

  #=== Constants ===
  #ROOM TYPE

  #=== Fields ===
  field :name, type: String
  field :type, type: Integer
  field :lat, type: String
  field :lng, type: String

  field :address, type: String
  field :phone, type: String
  field :description, type: String

  #=== Relations ===
  has_many :evaluations
  embeds_many :images
end
