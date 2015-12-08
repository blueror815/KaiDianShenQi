module Wixin
  def retrive_open_id(code)
    app_id = Rails.application.secrets.wechat_app_id
    app_secret = Rails.application.secrets.wechat_app_secret
   
    client = WeixinAuthorize::Client.new( app_id, app_secret)
    sns_info =  client.get_oauth_access_token(code).result
    sns_info["openid"]
  end
end
