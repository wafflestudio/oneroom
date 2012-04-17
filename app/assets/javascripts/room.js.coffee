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
  #= show room info
  showInfo: (map_inst, id) ->
    self = this
    status = this.getStatus()

    if(status)
      marker = map_inst.findPin(id)
      map_inst.showInfoWindow(id, marker)
    else
      call_func = () ->
        marker = map_inst.findPin(id)
        map_inst.showInfoWindow(id, marker)
      map_inst.addPins(self, id, call_func)


#variables
window.room = new Room
