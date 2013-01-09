window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "new"
    "users/find_password": "findPassword"
    "users/reauthorize": "reauthorize"
    "users/:id/edit": "edit"
    "users/:id/auth": "sendAuth"
    "users/:id/auth/:token": "auth"
  }

  new: () ->
    callback = () ->
      username = $("#session_username").val()
      if username and username.length > 0
        $("#user_username").val(username)
      $("#user_new_before a#submit").live("click", () ->
        $("#user_new_before").hide()
        $("#user_new_after").show()
      )
      successCallback = (res, status) ->
        user = window.user
        user.setSession(res.status)
        user.set(res.data)
        user.reload()
        $.colorbox.close()
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
        $("#user_new_after").hide()
        $("#user_new_before").show()
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/users/new", "#", callback)

  findPassword: () ->
    callback = () ->
      $("#find_password_before a#submit").live("click", () ->
        $("#find_password_before").hide()
        $("#find_password_after").show()
      )
      successCallback = (res, status) ->
        $.colorbox.close()
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
        $("#find_password_after").hide()
        $("#find_password_before").show()
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/users/find_password", "#", callback)

  reauthorize: () ->
    callback = () ->
      $("#reauthorize_before a#submit").live("click", () ->
        $("#reauthorize_before").hide()
        $("#reauthorize_after").show()
      )
      successCallback = (res, status) ->
        $.colorbox.close()
        flash_notice(res.msg)
      errorCallback =  (res, status) ->
        flash_error(res.msg)
        $("#reauthorize_after").hide()
        $("#reauthorize_before").show()
      submit_colorbox("#submit", successCallback, errorCallback)

    call_colorbox("/users/reauthorize", "#", callback)
   
 
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
    $(document).ready ->
      $.getJSON("/users/" + id + "/authorize/" + token, (res) ->
        flash_notice("인증 중..")
        if(res.status == "success")
          window.user.reload(true)
          flash_notice(res.msg)
        else
          flash_error(res.msg)
        window.nav.navigate("nav_map")
      )
})
