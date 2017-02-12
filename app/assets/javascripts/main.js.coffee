default_page = 1
sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)

onNext = ->
  $(".pagination").on "click", "#next", ->
    $("#main-div").html("")
    getAndBind(++default_page)
    console.log "am next"

onPrevious = ->
  $(".pagination").on "click", "#previous", ->
    $("#main-div").html("")
    getAndBind(--default_page)
    console.log "am previous"


getAndBind = (page_number) ->
  $(".loader").show()
  onError = (result, status, jqXHR) ->
    # $.notify("#{result.responseText}", "error")
    false

  onSuccess = (result, status, jqXHR) ->
    $(".loader").hide()
    console.log result.data
    result.data.forEach (camera) ->
      content = 
        "<div id='amBox'>
          <div id='image-top'>
            <img src='#{camera.image_src}' class='image-width'>
          </div>
          <div id='text-div'>#{camera.camera_name}</div>
          <div id='add-to-account'>
            Add Me
          </div>
        </div>"
      $("#main-div").prepend(content)
    true

  settings =
    cache: false
    dataType: 'json'
    error: onError
    success: onSuccess
    type: "GET"
    url: "http://localhost:4000/api/cameras/axis/#{page_number}"

  $.ajax(settings)

onPageLoad = ->
  $(window).load ->
    getAndBind(default_page)

window.initializeMain = ->
  onPageLoad()
  onPrevious()
  onNext()
