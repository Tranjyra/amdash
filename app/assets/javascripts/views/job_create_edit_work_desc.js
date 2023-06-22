function leaveChange() {
    EvaluateTextarea();
}


function EvaluateTextarea() {

    var jobTypeControl = $("#job_job_type_id option:selected");
    var control = $("#description");

    var controlDiv = $("#div_description");

    if (jobTypeControl.val() == "4") {
        if (controlDiv.hasClass('hidden')) controlDiv.removeClass('hidden');
        control.attr("required", true)
    } else {
        if (!controlDiv.hasClass('hidden')) controlDiv.addClass('hidden');
        control.removeAttr("required")
    }


}