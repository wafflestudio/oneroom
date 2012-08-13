window.App.Controllers.Room = Backbone.Router.extend({
  routes: {
    "rooms/:id": "showRoom"
    "rooms/new/:latlng": "newRoom"
    "rooms/:id/edit": "editRoom"
    "rooms/:id/photo": "photo"
    "rooms/:id/new_photo": "newPhoto"
    "rooms/:id/:options": "indexEvaluation"
    "rooms/:id/evaluations/new": "newEvaluation"
  }

  showRoom: (id) ->
    #TODO: don't reload showInfo if infowindow exist
    window.room.showInfo(id)

    call_colorbox("/rooms/" + id, "#map")

  newRoom: (latlng) ->
    pos = latlng.split(',')
    callback = () ->
      init_uploadify()
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
      successCallback = (res) ->
        id = res.data[0]._id
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
    
  newEvaluation: (id) ->
    window.room.showInfo(id)

    callback = () ->
      window.room.toggleEvalFields()
      successCallback = (res) ->
        call_colorbox("/rooms/" + id, "#map")
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/rooms/" + id + "/evaluations/new", "#map", callback)
})
