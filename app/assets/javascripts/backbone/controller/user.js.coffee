window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "new"
  }

  new: () ->
    callback = () ->
      cb = get_colorbox()
      submitButton = cb.find("#submit")
      form = $(submitButton.attr('rel'))
      submitButton.live('click', () ->
        form.ajaxSubmit({
          success: (res, status) ->
            if res.status == 'success'
              user = window.user
              user.setSession(res.status)
              user.set(res.data)
              user.reload()
              $.colorbox.close()
              flash_notice(res.msg)
            else
              flash_error(res.msg)
          error: (res, status) ->
            #TODO: humane alert
        })
      )

    call_colorbox("/users/new", "#", callback)
   
})
