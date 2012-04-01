class Image
  include Mongoid::Document

  #=== Fields ===
  field :image, type: String

  #=== Relations ===
  mount_uploader :image, ImageUploader
end
