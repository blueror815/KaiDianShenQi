#encoding: utf-8
module SMS

  # OneInfo is the provider we use now
  ONE_INFO_URL = "http://sms.1xinxi.cn/asmx/smsservice.aspx?"
  ACCOUNT = Rails.application.secrets.one_info_account
  PWD = Rails.application.secrets.one_info_password
  SINGANATURE = "草屋科技"
  TYPE = "pt"
  module OneInfo

    def self.send_text(text, number)
      uri = URI.parse(ONE_INFO_URL)
      response = Net::HTTP.post_form(uri, {
        "name" => ACCOUNT,
        "pwd" => PWD,
        "content" => text,
        "mobile" => number,
        "sign" => SINGANATURE,
        "type" => TYPE,
        "extno" => ""
      })
      response
    end
  end
end

