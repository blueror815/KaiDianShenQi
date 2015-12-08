module PushNotification
  module GeTui
    def send_push_notification(title, text, client_id)
      if client_id.blank?
        puts "can't send"
      else
        pusher = IGeTui.pusher(
            Rails.application.secrets.getui_app_id,
            Rails.application.secrets.getui_app_key,
            Rails.application.secrets.getui_master_secret
        )
        template = IGeTui::NotificationTemplate.new
        template.logo = 'push.png'
        template.logo_url = 'http://www.igetui.com/wp-content/uploads/2013/08/logo_getui1.png'
        template.title = title
        template.text = text
        single_message = IGeTui::SingleMessage.new
        single_message.data = template
        # create a client using SDK from GeTui
        client = IGeTui::Client.new(client_id)
        # send this push to a single client
        ret = pusher.push_message_to_single(single_message, client)
      end
    end
  end
end