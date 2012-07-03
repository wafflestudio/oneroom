#encoding: UTF-8
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

  #=== Functions ===
  def info 
    info = Hash.new
    evs = self.evaluations
   
    evs_re = evs.select{|e| e.type == Evaluation::RENT}
    evs_le = evs.select{|e| e.type == Evaluation::LEASE}
   
    info[:fee] = {Evaluation::RENT => Evaluation.most_common(evs_re, 'rent'), Evaluation::LEASE => Evaluation.most_common(evs_le, 'deposit')}
    info[:maintenance] = Evaluation.most_common(evs, 'maintenance')

    info
  end
end
