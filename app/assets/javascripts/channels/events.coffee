App.events = App.cable.subscriptions.create "EventsChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
      #$("div.event-menu").prepend(data['message'])
      $("div#events_list").prepend(data['message'])
      if data['event_count'] > 0
        $eventBadge =  $("#event-badge");
        $eventBadge.removeClass('d-none');
        $('#no_events_message').css('display','none');
        if(data['event_count']>3)
          $('#readall_div_top').css('display','block');
        $('#readall_div_bottom').css('display','block');
        $eventBadge[0].innerText = data['event_count']
        $eventsContainer = $('.events-container');
        if $eventsContainer.length > 0
          $eventsContainer.prepend $(data['message']).removeClass('event-card').attr('data-context', 'index')
      #$('#audioPlay').trigger('click');

