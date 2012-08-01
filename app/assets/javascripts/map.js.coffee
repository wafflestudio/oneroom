#class
class Map
  mapobj: null
  loc: null
  infowindow: null
  pins: []
  new_pin: null

  type: {
    new: 0,
    oneroom: 1,
    tworoom: 2,
    office: 3,
    boarding: 4
  }

  marker: {
    new: "/assets/marker/marker_new.png",
    oneroom: "/assets/marker/marker_oneroom.png",
    tworoom: "/assets/marker/marker_tworoom.png",
    office: "/assets/marker/marker_office.png",
    boarding: "/assets/marker/marker_boarding.png"
  }

  #==== INIT
  initLoc: () ->
    self = this
    self.loc = {
      default: new google.maps.LatLng(37.459300249665695, 126.95059418678284),
      nokdoo: new google.maps.LatLng(37.47060916727359, 126.9401228427887),
      entrance: new google.maps.LatLng(37.47883430817924, 126.95232152938843),
      nakseongdae: new google.maps.LatLng(37.47760825763003, 126.96056127548218)
    }

  initMap: () ->
    self = this
    #map options
    map_options = {
      center: self.loc.nokdoo,
      zoom: 18,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    }
    self.mapobj = new google.maps.Map(document.getElementById("map_canvas"), map_options)
    self.infowindow = new InfoBubble({
      content: "Loading..",
      maxWidth: 260,
      arrowPosition: 20,
      arrowSize:5,
      padding: 5
    })

    #show add room pin
    self.new_pin = new google.maps.Marker({
      id: 0,
      position: new google.maps.LatLng(37.459300249665695, 126.95059418678284)
      icon: self.getPinImage(self.type.new)
    })
    self.new_pin.setMap(self.mapobj)
    google.maps.event.addListener(self.mapobj, 'click', (event) ->
      pos = event.latLng
      pin = self.new_pin
      pin.setPosition(pos)
      pin.setVisible(true)
      
      infowindow = self.infowindow
      pos_str = pos.lat() + "," + pos.lng()
      $.getJSON("rooms/info_new?pos=" + pos_str, (res) ->
        infowindow.open(self.mapobj, pin)
        infowindow.setContent(res.html)
      )
    )

    #infowindow close event
    google.maps.event.addListener(self.infowindow, 'closeclick', () ->
      window.location.href = "#map"
      self.new_pin.setVisible(false)
    )

  #==== MAP ====
  #= move to location
  moveTo: (latlng) ->
    this.mapobj.panTo(latlng)

  #==== PIN ====
  #= pin to map
  addPins: (rooms) ->
    self = this
    $.each(rooms, (key, val) ->
      new_pin = new google.maps.Marker({
        position: new google.maps.LatLng(val.lat, val.lng),
        id: val._id,
        title: val.name,
        icon: self.getPinImage(val.type)
      })
      new_pin.setMap(self.mapobj)
      self.pins.push(new_pin)

      #listen click event
      google.maps.event.addListener(new_pin, 'click', (event) ->
        self.new_pin.setVisible(false)
        window.location.href = "#map/room/" + val._id
      )
    )
 
  #= remove all pins
  removePins: () ->
    self = this
    for pin in self.pins
      pin.setMap(null)
    self.pins = []

  #= find pins from id
  findPin: (id) ->
    self = this
    for pin in self.pins
      if(pin.id == id)
        return pin

  #= focus pin
  focusPin: (id) ->
    self = this
    self.moveTo(self.findPin(id).position)

  #= pin image
  getPinImage: (type) ->
    self = this
    if(type == self.type.oneroom)
      img = self.marker.oneroom
    else if(type == self.type.tworoom)
      img = self.marker.tworoom
    else if(type == self.type.office)
      img = self.marker.office
    else if(type == self.type.boarding)
      img = self.marker.boarding
    else if(type == self.type.new)
      img = self.marker.new
    return img

  #==== INFO WINDOW ====
  #= show info window
  showInfoWindow: (id, marker) ->
    #get marker if do not exist       
    infowindow = this.infowindow
    infowindow.setContent("loading..")
    infowindow.open(this.mapobj, marker)

    $.getJSON("rooms/" + id + "/info", (res) ->
      infowindow.setContent(res.html)
      infowindow.open(this.mapobj, marker)
    )
  
#variables
window.map = new Map
