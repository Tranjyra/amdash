$(document).on "turbolinks:load", ->
  $("body").on 'change', '#customFile', (e) ->
    $('#fileLabel').text e.target.files[0].name
    $('#previewFile').css 'max-height', $('#formFields').height
    $fileContent = $("#fileContent")
    if $fileContent.length > 0
      $fileContent.replaceWith("<img class='img-thumbnail' id='fileContent' style='max-height: inherit' src='#{URL.createObjectURL(e.target.files[0])}'></img>")
    else
      $('#previewFile').append "<img class='img-thumbnail' id='fileContent' style='max-height: inherit' src='#{URL.createObjectURL(e.target.files[0])}'></img>"
  $('body').on 'change', "#zoneSelect" ,  (e) ->
    zone_id = e.target.selectedOptions[0].value
    $.get '/staff',
      format: 'js'
      zone_id: zone_id
    return
