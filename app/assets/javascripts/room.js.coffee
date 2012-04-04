#class
class Room
  rooms = null
  pins = []

  #= get whole rooms
  get: (map) ->
    self = this

    $.getJSON("rooms", (res) ->
      rooms = res
      self.addPins(map, rooms)
    )

  #= pin marker to map
  addPins: (map, rooms) ->
    $.each(rooms, (key, val) ->
      new_pin = new google.maps.Marker({
        position: new google.maps.LatLng(val.lat, val.lng),
        title: val.name
      })
      new_pin.setMap(map)
      pins.push(new_pin)

      #listen click event
      google.maps.event.addListener(new_pin, 'click', (event) ->
        window.location.href = "#map/room/" + val._id
      )
    )

  #= remove all pins
  removePins: (map) ->
    $.each(pins, (key, val) ->
      val.setMap(null)
    )
    pins = []

#variables
window.room = new Room
