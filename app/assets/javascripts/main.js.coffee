sendAJAXRequest = (settings) ->
  token = $('meta[name="csrf-token"]')
  if token.size() > 0
    headers =
      "X-CSRF-Token": token.attr("content")
    settings.headers = headers
  xhrRequestChangeMonth = jQuery.ajax(settings)

getAndBind = (page_number) ->
  grandDiv = $("#main-div")
  onError = (result, status, jqXHR) ->
    # $.notify("#{result.responseText}", "error")
    false

  onSuccess = (result, status, jqXHR) ->
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
    getAndBind(1)

window.initializeMain = ->
  onPageLoad()
