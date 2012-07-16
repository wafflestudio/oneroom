#class
class Map
  mapobj: null
  loc: null
  infowindow: null
  pins: []

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
        title: val.name,
        id: val._id
      })
      new_pin.setMap(self.mapobj)
      self.pins.push(new_pin)

      #listen click event
      google.maps.event.addListener(new_pin, 'click', (event) ->
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
    window.map.moveTo(self.findPin(id).position)

  #==== INFO WINDOW ====
  #= show info window
  showInfoWindow: (id, marker) ->
    #get marker if do not exist       
    infowindow = this.infowindow
    infowindow.setContent("loading..")
    infowindow.open(this.mapobj, marker)

    $.getJSON("rooms/" + id + "/info", (res) ->
      infowindow.setContent(res.html)
    )
  
#variables
window.map = new Map
