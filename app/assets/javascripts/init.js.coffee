#functions
#=== Colorbox ===
@get_colorbox = () ->
  return $("#cboxLoadedContent")

@call_colorbox = (url, callback_url, callback_function) ->
  $.colorbox({
    href: url,
    transition: 'fade',
    width: '880px',
    close: '<button class="close">&times;</button>',
    escKey: false,
    arrowKey: false,
    onClosed: () ->
      if callback_url
        window.location.href = callback_url
        return false
    onComplete: () ->
      callback_function() if callback_function
  })

@submit_colorbox = (submitButton, success, error) ->
  cb = get_colorbox()
  submitButton = cb.find(submitButton)
  form = $(submitButton.attr('rel'))
  submitButton.die()
  submitButton.live('click', () ->
    form.ajaxSubmit({
      success: (res) ->
        if res.status == 'success'
          success(res)
        else
          error(res)
          if res.data != null
            model = res.data.model
            errors = res.data.errors
            if errors != null
              $(".control-group").removeClass("error")
              $(".help-inline").html("")
              $.each(errors, (key, val) ->
                if val.length > 1
                  res = ""
                  $.each(val, (key, val) ->
                    res = res + this + "<br>"
                  )
                else
                  res = val[0]
                $("#validation_" + model + "_" + key).parents(".control-group").addClass("error")
                $("#validation_" + model + "_" + key).html(res)
              )
      error: error
    })
  )

#=== qTip
@init_qtip = (div, callback_function) ->
  $(div).each ->
    self = $(this)
    $(this).qtip({
      content: {
        text: "<img src='/assets/loading.gif'>",
        ajax: {
          url: $(this).attr('rel'),
          type: 'GET',
          success: (data, status) ->
            this.set('content.text', data.html)
            $("#login_close").live('click', () ->
              self.qtip('hide')
            )
            $("#login_signup").live('click', () ->
              self.qtip('hide')
            )
            callback_function() if callback_function
            return true
        }
      },
      position: {
        my: 'top right',
        at: 'bottom right',
        target: self,
        adjust: {
          y: 10
        }
        effect: false # Disable positioning animation
      },
      show: {
        event: 'click'
      },
      hide: {
        event: 'unfocus'
      },
      style: {
        tip: {
          width: 10,
          height: 10,
          corner: 'top right'
        }
        classes: 'ui-tooltip-light ui-tooltip-shadow ui-tooltip-tip ui-tooltip-rounded'
      }
    })
    return false

#=== Humane ===
@flash_notice = (msg) ->
  humane.log(msg, {addnCls: 'human-jackedup-info'})

@flash_error = (msg) ->
  humane.log(msg, {addnCls: 'human-jackedup-error'})

#=== Uploadify
@init_uploadify = () ->
  $('input.uploadify_image_input').uploadify(
    swf: '/assets/uploadify/uploadify.swf',
    uploader: '/images#create',
    fileTypeExt : '*.png;*.jpg;*.jpeg;*.gif',
    multi: true,
    auto: true,
    onUploadSuccess: (file, data, status) ->
      if status
        res = $.parseJSON(data)
        new_name = $("#uploadify_image_original").attr('real_name')
        new_input = $("#uploadify_image_original").clone().attr('id', 'uploadify_cloned').attr('name', new_name)
        $("#uploadify_image_ids").append(new_input.val(res.data._id))
        $("#uploadify_image_thumbnails").append("<img src='" + res.data.image.thumb.url + "' />")
  )


get_height = () ->
  height = 500
  if $(window).height()-180 > 500
    height = $(window).height()-200
  return height

#init
$(document).ready ->

  #Accodion
  $("#nav").liteAccordion({
    containerWidth: 1030,
    containerHeight: get_height(),
    activateOn: 'click',
    firstSlide: 1,
    slideSpeed: 500,
    easing: 'easeInOutQuart'
  })
  $(".inner_container").height(get_height())

  #init locations
  window.map.initLoc()

  #load google map
  window.map.initMap()
  $("#map_canvas").height(get_height())

  #load room pins
  window.room.getRooms()

  #init search
  window.search.initSearch()

  #load search sliders
  window.search.initSlider("#rent_deposit", 0, 1200, 200, 500)
  window.search.initSlider("#rent_rent", 0, 80, 30, 40)
  window.search.initSlider("#lease_deposit", 2000, 10000, 3000, 7000)

  #session load
  window.user.reload()

###
