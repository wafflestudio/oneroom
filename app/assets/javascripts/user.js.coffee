#class
class User
  session_div: "#session"
  login_button: "a#login"
  logout_button: "a#logout"

  session: false
  data: null

  #==== SESSION ====
  getSession: () ->
    return session

  setSession: (status) ->
    self = this
    self.session = status

  reload: () ->
    self = this
    $.get("/session", (res) ->
      $(self.session_div).html(res.html)
      if res.session == null
        self.setSession(false)
        callback = () ->
          $(self.login_button).live('click', () ->
            self.login()
          )
        init_qtip(".qtip2", callback)
      else
        self.setSession(true)
        $(self.logout_button).live('click', () ->
          self.logout()
        )
    )

  login: () ->
    self = this
    form = $($(self.login_button).attr('rel'))
    form.ajaxSubmit({
      success: (res, status) ->
        if res.status == 'success'
          flash_notice(res.msg)
          self.setSession(true)
          self.set(res.data)
          self.reload()
        else
          flash_error(res.msg)
    })

  logout: () ->
    self = this
    $.ajax("/session", {
      type: 'DELETE',
      success: (res, status) ->
        self.reload()
    })

  #==== USER ====
  get: () ->
    return data

  set: (user) ->
    self = this
    self.data = user

#variables
window.user = new User
