#encoding: UTF-8
class Room
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongoid::Timestamps::Updated

  #=== Constants ===
  #REGION TYPE
  NOKDOO = {:id => 1, :name => "녹두"}
  ENTRANCE = {:id => 2, :name => "서울대입구"}
  NAKSEONGDAE = {:id => 3, :name => "낙성대"}

  REGION = [NOKDOO, ENTRANCE, NAKSEONGDAE]

  #ROOM TYPE
  ONEROOM = {:id => 1, :name => "원룸"}
  TWOROOM = {:id => 2, :name => "투룸 이상"}
  OFFICETEL = {:id => 3, :name => "오피스텔"}
  BOARDING = {:id => 4, :name => "하숙"}

  TYPE = [ONEROOM, TWOROOM, OFFICETEL, BOARDING]

  #SEARCH TYPE
  SEARCH_BASIC = 1
  SEARCH_ADVANCED = 2

  PER_PAGE = 10
  #=== Fields ===
  field :name, type: String
  field :type, type: Integer
  field :image_ids, type: Array, default: []

  field :lat, type: String
  field :lng, type: String
  
  field :region, type: Integer
  field :address, type: String
  field :phone, type: String

  field :etc, type: String
  field :description, type: String

  #=== Relations ===
  has_many :evaluations
  embeds_many :images

  #=== Validations ===
  validates_presence_of :name, :message => "이름을 입력해주세요."

  #=== Functions ===
  def self.add_room params
    r = Room.new(params)
    if r.save
      return r
    else
      r.destroy
    end
    nil
  end

	def self.option_for_type
		v = []
		TYPE.each do |e|
			v << [e[:name], e[:id]]
		end
		v
	end

	def self.option_for_region
		v = []
		REGION.each do |e|
			v << [e[:name], e[:id]]
		end
		v
	end

  def info 
    info = Hash.new
    evs = self.evaluations
    info[:size] = evs.size
 
    evs_like = evs.select{|e| e.like}
    evs_dislike = evs.select{|e| !e.like}

    info[:like] = {:true => evs_like.count, :false => evs_dislike.count}

    unless evs.size > 0
      return info
    end

    evs_re = evs.select{|e| e.type == Evaluation::RENT}
    evs_le = evs.select{|e| e.type == Evaluation::LEASE}
   
    info[:fee] = {Evaluation::RENT => Evaluation.most_common(evs_re, 'rent'), Evaluation::LEASE => Evaluation.most_common(evs_le, 'deposit')}
    info[:maintenance] = Evaluation.most_common(evs, 'maintenance')

    info
  end

  def type_name
    TYPE.each do |t|
      if self.type == t[:id]
        return t[:name]
      end
    end
  end

  def region_name
    REGION.each do |t|
      if self.type == t[:id]
        return t[:name]
      end
    end
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
        rooms = Room.where(:name => /#{params[:search][:keyword]}/, :region.in => regions, :_id.in => room_ids)
      else
        rooms = Room.where(:name => /#{params[:search][:keyword]}/, :region.in => regions)
      end
    end

    rooms.page(params[:page]).per(Room::PER_PAGE)
  end
end
