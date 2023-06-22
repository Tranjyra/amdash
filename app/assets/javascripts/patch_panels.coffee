
$(document).on 'turbolinks:load', ->
  $('#patch-panel').on 'dblclick', 'div.port', (e) ->
    $('#exampleModalCenter').modal 'toggle'
    $('#portModalTitle').html "<h5> Порт номер #{$(e.currentTarget).attr('data-port')} </h5>"
    portId = $(e.currentTarget).attr 'data-port-id'
    panelId = $('div.patch-panel').attr 'data-panel-id'
    jobId = $('div.patch-panel').attr 'data-job-id'
    $.get "/jobs/#{jobId}/patch_panels/#{panelId}/ports/#{portId}/edit",
      format: 'js'
    return