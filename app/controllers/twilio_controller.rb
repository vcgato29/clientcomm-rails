class TwilioController < ApplicationController
  skip_before_action :verify_authenticity_token

  def incoming_sms
    # TODO: error handling
    # get the client based on the phone number
    client = Client.find_by(phone_number: params[:From])
    # create a new message
    new_message_params = {client: client, user_id: client.user_id, number_to: ENV['TWILIO_PHONE_NUMBER'], number_from: params[:From], inbound: true, twilio_sid: params[:SmsSid], twilio_status: params[:SmsStatus], body: params[:Body]}

    message = Message.create(new_message_params)

    # broadcast the message on ActionCable
    message_html = render_to_string partial: 'messages/message', locals: {message: message}
    ActionCable.server.broadcast "messages_#{message.client_id}",
      message_html: message_html

    head :no_content
  end

  def incoming_sms_status
    # TODO: error handling
    # update the status of the corresponding message in the database
    message = Message.find_by twilio_sid: params[:SmsSid]
    message.update(twilio_status: params[:SmsStatus])

    head :no_content
  end

  def incoming_voice

  end

end
