#class
class Map
  mapobj: null
  loc: null
  infowindow: null
  pins: []

  #= move to location
  moveTo: (loc_id) ->
    this.mapobj.panTo(this.loc[loc_id])

  #==== PIN ====
  #= pin to map
  addPins: (room_inst, id, callback) ->
    self = this
    room_inst.setStatus(0)

    url = "rooms"
    url += "?" + "id=" + id if id

    $.getJSON(url, (res) ->
      $.each(res, (key, val) ->
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
  
      room_inst.setStatus(1)
      callback() if callback
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
