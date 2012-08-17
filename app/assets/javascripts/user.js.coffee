#class
class User
  session_div: "#session"
  login_button: "a#login"
  login_field: "input.field_login"
  logout_button: "a#logout"

  session: false
  data: null

  #==== SESSION ====
  needSessionLoad: () ->
    status = parseInt($("#need_session").html())
    if(status == 0)
      return false
    else
      return true

  getSession: () ->
    return session

  setSession: (status) ->
    self = this
    self.session = status

  reload: (no_cache) ->
    self = this
    if no_cache
      url = "/session?no_cache"
    else
      url = "/session"

    $.get(url, (res) ->
      self.reload_html(res.html)
      if res.data == null
        self.setSession(false)
        callback = () ->
          $(self.login_field).live('keypress', (e) ->
            if e.keyCode == 13
              self.login()
          )
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

  reload_html: (html) ->
    self = this
    $(self.session_div).html(html)

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
