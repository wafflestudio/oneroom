#encoding: UTF-8
class Evaluation
  include Mongoid::Document

  #=== Constants ===
  #ROOM TYPE
  RENT = 1
  LEASE = 2

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

  field :agree, type: Array, default: []
  field :disagree, type: Array, default: []

  #=== Relations ===
  belongs_to :user
  belongs_to :room

  #=== Validations ===
  validates_presence_of :content
  validates_presence_of :like

  validates_presence_of :type
  validates_presence_of :deposit
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

  def self.most_common evs, att
    #해당 att가 가장 흔한 애들 중 가장 최근 evaluation object를 리턴
    unless evs
      return nil
    end

    groups = evs.group_by{|g| g[att]}.max_by{|x| x.count}
    if groups
      return groups.last.last
    else
      return nil
    end
  end

  def type_name
    if self.type == RENT
      return '월세'
    elsif self.type == LEASE
      return '전세'
    end
  end

  def fee
    if self.type == RENT
      return deposit.to_s + "/" + rent.to_s
    elsif self.type == LEASE
      return deposit.to_s
    end
  end

  def maintenance_detail
    unless self.gas or self.electricity or self.water
      return "가스, 전기 등 비용 미포함"
    end

    res = ""
    if self.gas
      res = res + "가스비"
    end
    if self.electricity
      res = res + "전기료"
    end
    if self.water
      res = res + "수도료"
    end
    res = res + " 포함"
    res
  end
end
