#class
class Room
  rooms: null


  #==== STATUS ====
  #= get status
  getStatus: () ->
    status = $("#status").html()
    if(status == "0" or status == 0)
      return false
    else
      return true

  #= set status
  setStatus: (status) ->
    $("#status").html(status)

  #==== ROOM ====
  #= get rooms on condition
  getRooms: (id, callback) ->
    self = this
    self.setStatus(0)
  
    url = "rooms"
    url += "?" + "id=" + id if id

    $.getJSON(url, (res) ->
      window.map.addPins(res.data)
      self.setStatus(1)
      callback() if callback
    )

  #= show room info
  showInfo: (id) ->
    self = this
    status = this.getStatus()

    if(status)
      marker = window.map.findPin(id)
      window.map.showInfoWindow(id, marker)
    else
      call_func = () ->
        marker = window.map.findPin(id)
        window.map.showInfoWindow(id, marker)
      self.getRooms(id, call_func)

#variables
window.room = new Room
