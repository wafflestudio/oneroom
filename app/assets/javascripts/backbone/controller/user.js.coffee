window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "new"
  }

  new: () ->
    callback = () ->
      successCallback = (res, status) ->
        user = window.user
        user.setSession(res.status)
        user.set(res.data)
        user.reload()
        $.colorbox.close()
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/users/new", "#", callback)
   
})
