$(document).ready(function() {
  chatroomId = $('input#message_chatroom_id').val();
  App.messages = App.cable.subscriptions.create({channel: 'MessagesChannel',
    chatroom_id: chatroomId}, {
    received: function(data) {
      $('#messages').removeClass('hidden')
      return $('#messages').append(this.renderMessage(data));
    },
    chatroom_id: function(data) {
      return data.chatroom_id
    },
    renderMessage: function(data) {
      $('#qnimate').addClass('popup-box-on');
      $('#scroll').animate({scrollTop: $('#scroll')[0].scrollHeight}, 1000);
      return data.message
    }
  });
})
