#functions
#=== Colorbox ===
@get_colorbox = () ->
  return $("#cboxLoadedContent")

@call_colorbox = (url, callback_url, callback_function) ->
  $.colorbox({
    href: url,
    transition: 'fade',
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
      error: error
    })
  )

#=== qTip
@init_qtip = (div, callback_function) ->
  $(div).each ->
    $(this).qtip({
      content: {
        text: 'loading...',
        ajax: {
          url: $(this).attr('rel'),
          type: 'GET',
          success: (data, status) ->
            this.set('content.text', data.html)
            callback_function() if callback_function
            return true
        },
        title: {
          text: $(this).attr('title'),
          button: true
        }
      },
      position: {
        at: 'bottom center', # Position the tooltip above the link
        my: 'top center',
        viewport: $(window), # Keep the tooltip on-screen at all times
        effect: false # Disable positioning animation
      },
      show: {
        event: 'click'
      },
      hide: {
        event: 'unfocus'
      },
      style: {
        classes: 'ui-tooltip-wiki ui-tooltip-light ui-tooltip-shadow'
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


#init
$(document).ready ->
  #Accodion
  $("#nav").liteAccordion({
    containerWidht: 960,
    containerHeight: 500,
    activateOn: 'click',
    firstSlide: 2,
    slideSpeed: 500,
    easing: 'easeInOutQuart'
  })

  #init locations
  window.map.initLoc()

  #load google map
  window.map.initMap()

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
