window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "new"
    "users/:id/edit": "edit"
    "users/:id/auth": "sendAuth"
    "users/:id/auth/:token": "auth"
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
 
  edit: (id) ->
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

    call_colorbox("/users/" + id + "/edit", "#", callback)


  sendAuth: (id) ->
    $.getJSON("/users/" + id + "/require_authorize_token", (res) ->
      if(res.status == "success")
        flash_notice(res.msg)
      else
        flash_error(res.msg)
    )

  auth: (id, token) ->
    $.getJSON("/users/" + id + "/authorize/" + token, (res) ->
      if(res.status == "success")
        flash_notice(res.msg)
      else
        flash_error(res.msg)
      window.user.reload()
      window.nav.navigate("nav_map")
    )
})
