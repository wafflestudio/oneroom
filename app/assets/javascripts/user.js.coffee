#class
class User
  div: "#session"
  session: false
  data: null

  #==== SESSION ====
  getSession: () ->
    return session

  setSession: (status) ->
    self = this
    self.session = status

  reload: () ->
    $.get("/session", (res) ->
      console.log(res)
      $(div).html(res.html)
    )

  #==== USER ====
  get: () ->
    return data

  set: (user) ->
    self = this
    self.data = user

#variables
window.user = new User
