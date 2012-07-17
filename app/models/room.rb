#encoding: UTF-8
class Room
  include Mongoid::Document

  #=== Constants ===
  #REGION TYPE
  NOKDOO = 1
  ENTRANCE = 2
  NAKSEONGDAE = 3

  #ROOM TYPE

  #SEARCH TYPE
  SEARCH_BASIC = 1
  SEARCH_ADVANCED = 2

  #=== Fields ===
  field :name, type: String
  field :type, type: Integer
  field :lat, type: String
  field :lng, type: String
  
  field :region, type: Integer
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

    evs_like = evs.select{|e| e.like}
    evs_dislike = evs.select{|e| !e.like}

    info[:like] = {:true => evs_like.count, :false => evs_dislike.count}
    info
  end

  def self.search params
    if params[:search][:type].to_i != SEARCH_ADVANCED
      rooms = Room.where(:name => /#{params[:search][:keyword]}/)
    else
      regions = params[:region].select{|k, v| v == "true"}.keys.collect{|r| r.to_i}

      if params[:type][:rent] == "true" or params[:type][:lease] == "true"
        evs = Array.new

        if params[:type][:rent] == "true"
          evs_r = Evaluation.where(:type => Evaluation::RENT, :deposit.gte => params[:rent][:deposit_min], :deposit.lte => params[:rent][:deposit_max], :rent.gte => params[:rent][:rent_min], :rent.lte => params[:rent][:rent_max])
          evs = evs + evs_r
        end

        if params[:type][:lease] == "true"
          evs_l = Evaluation.where(:type => Evaluation::LEASE, :deposit.gte => params[:lease][:deposit_min], :deposit.lte => params[:lease][:deposit_max])
          evs = evs + evs_l
        end

        room_ids = evs.flatten.collect{|e| e.room.id}.uniq
        rooms = Room.where(:name => /#{params[:search][:keyword]}/, :region.in => regions).find(room_ids)
      else
        rooms = Room.where(:name => /#{params[:search][:keyword]}/, :region.in => regions)
      end
    end

    rooms.paginate(:page => params[:page], :per_page => 10)
  end
end
