#class
class Nav
  #= move to accordion
  navigate: (nav_id) ->
    $("#" + nav_id).trigger('click')

    if nav_id == "nav_map" and window.search.getResultStatus()
      window.search.showResult()
    else
      window.search.hideResult()


  #= contact mail
  contact: () ->
    $("#send_contact").live('click', () ->
      self = this
      form = $(self).attr('rel')
      params = $(form).formSerialize()

      $(self).hide()
      $.post("/main/contact", params, (res) ->
        if res == "success"
          flash_notice(res.msg)
        else
          flash_error(res.msg)

        $(self).show()
      )
    )
  
#variables
window.nav = new Nav

