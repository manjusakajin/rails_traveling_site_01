$(document).on('turbolinks:load', function() {
  submitNewMessage();
});

submitNewMessage = function(){
  $('textarea#message_content').keydown(function(event) {
    if (event.keyCode == 13) {
        $('[data-send="message"]').click();
        $('[data-textarea="message"]').val(" ")
        return false;
     }
  });
}

$(function(){
  $(document).on("click", "#addClass", function(){
    $('#qnimate').addClass('popup-box-on');
    $("#scroll").scrollTop($("#scroll")[0].scrollHeight);
  });

  $(document).on("click", "#removeClass", function(){
    $('#qnimate').removeClass('popup-box-on');
  });
})
