window.App.Controllers.Room = Backbone.Router.extend({
  routes: {
    "rooms/:id": "showRoom"
    "rooms/:id/evaluations/new": "newEvaluation"
    "rooms/new/:latlng": "newRoom"
  }

  showRoom: (id) ->
    #TODO: don't reload showInfo if infowindow exist
    window.room.showInfo(id)

    call_colorbox("/rooms/" + id, "#map")

  newEvaluation: (id) ->
    #TODO: don't reload showInfo if infowindow exist
    window.room.showInfo(id)

    callback = () ->
      successCallback = (res) ->
        call_colorbox("/rooms/" + id, "#map")
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/" + id + "/evaluations/new", "#map", callback)

  newRoom: (latlng) ->
    pos = latlng.split(',')
    callback = () ->
      successCallback = (res) ->
        window.map.new_pin.setVisible(false)
        window.map.addPins(res.data)
        $.colorbox.close()
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/new?lat=" + pos[0] + "&lng=" + pos[1], "#map", callback)
})
