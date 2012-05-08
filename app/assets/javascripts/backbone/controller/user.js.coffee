window.App.Controllers.User = Backbone.Router.extend({
  routes: {
    "users/new": "new"
  }

  new: () ->
    callback = () ->
      cb = get_colorbox()
      submitButton = cb.find("#submit")
      form = $(submitButton.attr('rel'))
      submitButton.click(() ->
        form.ajaxSubmit({
          success: (res, status) ->
            console.log(res)
            data = res.data
            if res.status == 'success'
              user = window.user
              user.setSession(data.status)
              user.set(data.data)
              $.colorbox.close()
              user.reload
            else
              #TODO: humane alert, reload _header
          error: (res, status) ->
            #TODO: humane alert
        })
      )

    call_colorbox("/users/new", "#", callback)
   
})
