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
  data = {}
  data.page_number = page_number
  $(".loader").show()
  onError = (result, status, jqXHR) ->
    # $.notify("#{result.responseText}", "error")
    false

  onSuccess = (result, status, jqXHR) ->
    $(".loader").hide()
    console.log result
    result.forEach (camera) ->
      content = 
        "<div id='amBox'>
          <div id='image-top'>
            <img src='#{camera.image_url}' class='image-width'>
          </div>
          <div id='text-div'>#{camera.title}</div>
          <div class='add-to-account' camera-name='#{camera.name}' camera-vendor='#{camera.vendor}' camera-ip='#{camera.external_host}' camera-port='#{camera.external_http_port}' user-api-id='#{camera.api_id}' user-api-key='#{camera.api_key}'>
            Add Me
          </div>
        </div>"
      $("#main-div").prepend(content)
    true

  settings =
    cache: false
    dataType: 'json'
    data: data
    error: onError
    success: onSuccess
    type: "GET"
    url: "/load_cameras_details"

  $.ajax(settings)

onPageLoad = ->
  $(window).load ->
    getAndBind(default_page)

onAddCamera = ->
  $("body").on "click", "div.add-to-account", ->
    data = {}
    data.name = $(this).attr("camera-name")
    data.vendor = $(this).attr("camera-vendor")
    data.external_http_port = $(this).attr("camera-port")
    data.external_host = $(this).attr("camera-ip")
    data.api_id = $(this).attr("user-api-id")
    data.api_key = $(this).attr("user-api-key")
    sendToDB(data)

sendToDB = (data) ->
  $(".loader").show()
  onError = (result, status, jqXHR) ->
    # $.notify("#{result.responseText}", "error")
    false

  onSuccess = (result, status, jqXHR) ->
    $(".loader").hide()
    console.log result
    true

  settings =
    cache: false
    dataType: 'json'
    data: data
    error: onError
    success: onSuccess
    type: "POST"
    url: "https://media.evercam.io/v1/cameras"

  $.ajax(settings)

window.initializeMain = ->
  onPageLoad()
  onPrevious()
  onNext()
  onAddCamera()
