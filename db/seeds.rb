#coding: utf-8

#room
room1 = Room.create(:name => "쉘브르고시텔", :lat => 37.47032178185495, :lng => 126.9401121139526)
room2 = Room.create(:name => "송원고시원", :lat => 37.47088165020561, :lng => 126.93991363048553)

default_image = Image.create(:image => File.open("#{Rails.root}/public/seeds/default.jpg"))
