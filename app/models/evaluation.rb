class Evaluation
  include Mongoid::Document

  #=== Fields ===
  field :content, type: String

  #=== Relations ===
  has_one :user

end
