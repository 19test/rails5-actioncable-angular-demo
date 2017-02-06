class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from stream_name
  end

  def receive(data)
    ActionCable.server.broadcast stream_name, data.fetch('message')

    # data: {"message"=>{"data"=>"1111111111", "extra"=>12}}
    logger.info "data: " + data.to_s
    logger.info "data.message.data: " + data['message']['data'].to_s
    logger.info "data.message.extra: " + data['message']['extra'].to_s
  end

  private

  def stream_name
    "chat_channel_#{chat_id}"
  end

  def chat_id
    params.fetch('data').fetch('chat')
  end
end
