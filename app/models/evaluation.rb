class Evaluation
  include Mongoid::Document

  #=== Fields ===
  field :content, type: String
  field :like, type: Boolean

  field :type, type: Integer #월세/전세
  field :deposit, type: Integer
  field :rent, type: Integer

  field :maintenance, type: Integer
  field :gas, type: Boolean
  field :electricity, type: Boolean
  field :water, type: Boolean

  #=== Relations ===
  belongs_to :user
  belongs_to :room

  #=== Validations ===
  validates_presence_of :content
  validates_presence_of :like

  validates_presence_of :type
  validates_presence_of :rent
  validates_numericality_of :rent, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :deposit, :only_integer => true, :greater_than_or_equal_to => 0

  validates_presence_of :maintenance
  validates_numericality_of :maintenance, :only_integer => true, :greater_than_or_equal_to => 0

  #=== Functions ===
  def self.add_evaluation eval_param, user, room
    ev = Evaluation.new(eval_param)
    ev.user = user
    ev.room = room

    if ev.save
      return ev
    else
      ev.destroy
    end
    nil
  end

end
