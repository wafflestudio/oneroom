#class
class Room
  rooms: null
  pins: []

  #= get rooms
  get: (map, params) ->
    self = this
    url = "rooms"
    url += "?" + params if params

    $.getJSON(url, (res) ->
      rooms = res
      self.addPins(map, rooms)
    )

  #= pin marker to map
  addPins: (map, rooms) ->
    self = this

    $.each(rooms, (key, val) ->
      new_pin = new google.maps.Marker({
        position: new google.maps.LatLng(val.lat, val.lng),
        title: val.name,
        id: val._id
      })
      new_pin.setMap(map)
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
    pins = []

  #= find pins from id
  findPin: (id) ->
    self = this
    for pin in self.pins
      if(pin.id == id)
        return pin


#variables
window.room = new Room
