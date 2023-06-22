

function remove_event_from_dropdown(eventId, unreadedEvents){
    $eventCard = $(`#event-card-${eventId}`);
    if ($eventCard.length > 0){
        $eventCard.remove();
    }
    $eventBadge = $('#event-badge');
    if (unreadedEvents < 1){
        $eventBadge.addClass('d-none');
        $('#readall_div_top').css('display','none');
        $('#readall_div_bottom').css('display','none');
        $('#no_events_message').css('display','block');
    }
    else{
        $eventBadge[0].innerText = unreadedEvents;

        $('#readall_div_top').css('display',(unreadedEvents > 3)?'block':'none');
        $('#readall_div_bottom').css('display','block');
        $('#no_events_message').css('display','none');
    }

}

function remove_all_events_from_dropdown(unreadedEvents){

    $(".eventblock").each(function( index ) {
        $("#"+$(this).attr('id')+"").remove();
    });

    $eventBadge = $('#event-badge');
    if (unreadedEvents < 1){
        $eventBadge.addClass('d-none');
        $('#readall_div_top').css('display','none');
        $('#readall_div_bottom').css('display','none');
        $('#no_events_message').css('display','block');
    }
    else{
        $eventBadge[0].innerText = unreadedEvents;

        $('#readall_div_top').css('display',(unreadedEvents > 3)?'block':'none');
        $('#readall_div_bottom').css('display','block');
        $('#no_events_message').css('display','none');
    }


}

let lastRequest;

function storeLastRequest(request){
    lastRequest = request;
}

function getLastRequest(){
    return lastRequest;
}

function modal_clear(){
    $('h5[data-target="modal-title"]').html("");
    $('div[data-target="modal-body"]').html("");
}

function modal_loading_show(){
    $("#loading_image_modal").css('display','block');
}