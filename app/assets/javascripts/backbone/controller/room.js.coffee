window.App.Controllers.Room = Backbone.Router.extend({
  routes: {
    "rooms/:id": "showRoom"
    "rooms/:id/evaluations/new": "newEvaluation"
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

})
