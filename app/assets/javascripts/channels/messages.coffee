$(document).on 'turbolinks:load', ->
  messages = $('#messages')
  if $('#messages').length > 0
    messages_to_bottom = -> $('body').scrollTop($('body')[0].scrollHeight)

    messages_to_bottom()
  App.messages = App.cable.subscriptions.create {
      channel: "MessagesChannel"
      conversation_id: messages.data('conversation-id')
    },
    connected: ->

    disconnected: ->

    received: (data) ->
      unless data.message.blank?
        messages.append(data['message'])
        messages_to_bottom()
        #$('body').scrollTop(10000);

    send_message: (message, conversation_id) ->
      @perform 'send_message', message: message, conversation_id: conversation_id


    $('#message_body').on 'keydown', (event) ->
      $this = $(this)
      content = $this.val()
      if event.keyCode is 13 && $.trim(content.length) > 1
        $('input').click()
        App.messages.send_message(content, messages.data('conversation-id'))
        event.target.value = ''
        event.preventDefault()
