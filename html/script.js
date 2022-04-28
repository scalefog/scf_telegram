//Global variabels 
var postname;

function loadInbox(list){
    $('#inboxList').empty();
    if(list.length > 0) {
        list.forEach(function(letter){
            if(letter.status == 1){
                $("#inboxList").append(`<li class="inbox_row" data-id="`+letter.id+`"><div class="inbox_subject"><i class="fa fa-envelope-open"></i> `+letter.subject+`</div><div class="inbox_sender">`+letter.sender+`</div><div class="inbox_date">`+letter.sentTime+`</div><a href="#"><i class="fa fa-trash-alt"></i></a></li>`);
            }else{
                $("#inboxList").append(`<li class="inbox_row" data-id="`+letter.id+`"><div class="inbox_subject"><i class="fa fa-envelope"></i> <b>`+letter.subject+`</b></div><div class="inbox_sender">`+letter.sender+`</div><div class="inbox_date">`+letter.sentTime+`</div><a href="#"><i class="fa fa-trash-alt"></i></a></li>`);
            }
        });
    }else{
        $(".inboxContainer").text("No telegram")
    }
}
//Close view Or compose
$(".close_view").on("click", function () {
    $(".view").fadeOut().hide();
    $(".compose").fadeOut().hide();
    $(".inbox").fadeIn().show();
});
//Compose button
$(".composetelegram").on("click",function(){
    $(".compose").fadeIn().show();
    $(".inbox").fadeOut().hide();
});
//Close post office
$(".closePostoffice").on("click",function(){
    $.post('http://scf_telegram/NUIFocusOff', JSON.stringify({}));
});
//Form 
$("#composeForm").submit(function(e){
    e.preventDefault(); // Prevent form from submitting
    //Send 
    var recipient = $("#recipient").val();
    var subject =  $("#subject").val();
    var message = $("#message").val();
    
    $.post('http://scf_telegram/sendTelegram', JSON.stringify({recipient:recipient,subject:subject,message:message,postoffice:postname}));
    //Reset form 
    $("#recipient").val('');
    $("#subject").val('');
    $("#message").val('');
    //Close form 
    $(".compose").fadeOut().hide();
    //Show inbox
    $(".inbox").fadeIn().show();

});

$(function () {
    window.addEventListener('message', function (event) {
        if (event.data.type === "openGeneral") {
            postname = event.data.postname;
            $('.inbox').css('display', 'block');
            $('#postname').text(postname)
        
            let today = new Date().toLocaleDateString();
            $('#today').text(today);
        
        }
        if(event.data.type === "view"){
            $("#view_recipient").text(event.data.telegram.recipient)
            $("#view_sender").text(event.data.telegram.sender)
            $("#view_date").text(event.data.telegram.sentTime)
            $("#view_subject").text(event.data.telegram.subject)
            $("#view_message").text(event.data.telegram.message)
        }
        if(event.data.type === "inboxlist"){
            loadInbox(event.data.response.list);
            $('#firstname').text(event.data.response.firstname);
            $("#postbox").text(event.data.response.box)
        }
        if (event.data.type === "closeAll") {
            $('.inbox').css('display', 'none')
            $('.compose').css('display', 'none')
            $('.view').css('display', 'none')
        }
    });
//View
});

$(document).ready(function(){
    $("#inboxList").on("click",'li',function(event){
        itemToDel = $(this).data('id');
        $.post('http://scf_telegram/getview', JSON.stringify({id: $(this).data('id')}));
       $(".inbox").fadeOut().hide();
       $(".view").fadeIn().show();
    });
});

$(".telegram_delete_button").click(function(event){
    $.post('http://scf_telegram/delete', JSON.stringify({id: itemToDel}));
    $(".inbox").fadeIn().show();
    $(".view").fadeOut().hide();
});

document.keyup = function (data) {
    if (data.which == 27) {
        $.post('http://scf_telegram/NUIFocusOff', JSON.stringify({}));
    }
}