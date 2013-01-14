window.App.Controllers.Room = Backbone.Router.extend({
  routes: {
    "rooms/:id": "showRoom"
    "rooms/new/:latlng": "newRoom"
    "rooms/:id/edit": "editRoom"
    "rooms/:id/photo": "photo"
    "rooms/:id/new_photo": "newPhoto"
    "rooms/:id/:options": "indexEvaluation"
    "rooms/:room_id/evaluations/new": "newEvaluation"
    "rooms/:room_id/evaluations/:id/edit": "editEvaluation"
  }

  showRoom: (id) ->
    window.room.showInfo(id)

    call_colorbox("/rooms/" + id, "#map")

  newRoom: (latlng) ->
    pos = latlng.split(',')
    callback = () ->
      init_uploadify()
      window.map.initSmallMap(pos[0], pos[1], true, $("#room_lat"), $("#room_lng"))
      successCallback = (res) ->
        id = res.data[0]._id
        window.map.new_pin.setVisible(false)
        window.map.addPins(res.data)
        window.location.href = "/#rooms/" + id
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/new?lat=" + pos[0] + "&lng=" + pos[1], "#map", callback)

  editRoom: (id) ->
    callback = () ->
      init_uploadify()
      window.map.initSmallMap($("#room_lat").val(), $("#room_lng").val(), true, $("#room_lat"), $("#room_lng"))
      successCallback = (res) ->
        id = res.data[0]._id

        former_pin = window.map.findPin(id)
        former_pin.setMap(null)
        window.map.pins.splice(window.map.pins.indexOf(former_pin), 1)
        window.map.addPins(res.data)

        window.location.href = "/#rooms/" + id
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/" + id + "/edit", "#map", callback)
  
  photo: (id) ->
    callback = () ->
      window.room.showPhoto('.photo_thumbs img', '.photo_original')
      $.colorbox.resize()

    call_colorbox("/rooms/" + id + "/photo", "#map", callback)

  newPhoto: (id) ->
    callback = () ->
      init_uploadify()
      $.colorbox.resize()
      successCallback = (res) ->
        id = res.data[0]._id
        window.location.href = "/#rooms/" + id + "/photo"
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)


    call_colorbox("/rooms/" + id + "/new_photo", "#map", callback)


  indexEvaluation: (id, options) ->
    self = this
    if $("#colorbox").css("display") == "none"
      self.showRoom(id)

    callback = () ->
      $.colorbox.resize()

    window.room.getEvaluations(id, options, callback)
    
  newEvaluation: (room_id) ->
    window.room.showInfo(room_id)

    callback = () ->
      window.room.toggleEvalFields()
      successCallback = (res) ->
        window.location.href = "/#rooms/" + room_id
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/" + room_id + "/evaluations/new", "#map", callback)

 
  editEvaluation: (room_id, id) ->
    window.room.showInfo(room_id)

    callback = () ->
      window.room.toggleEvalFields()
      successCallback = (res) ->
        window.location.href = "/#rooms/" + room_id
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/" + room_id + "/evaluations/" + id + "/edit", "#map", callback)
})
