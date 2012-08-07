#coding: utf-8

#room
room1 = Room.create(:name => "쉘브르고시텔", :lat => 37.47032178185495, :lng => 126.9401121139526, :region => 1, :type => 3, :address => "녹두 어딘가", :phone => "010-1234-5678", :description => "여기는 테스트 1입니다")
room2 = Room.create(:name => "송원고시원", :lat => 37.47088165020561, :lng => 126.93991363048553, :region => 1, :type => 1, :address => "녹두 어딘가23", :phone => "016-1234-5678", :description => "여기는 테스트 2입니다")

default_image = Image.create(:image => File.open("#{Rails.root}/public/seeds/default.jpg"))
