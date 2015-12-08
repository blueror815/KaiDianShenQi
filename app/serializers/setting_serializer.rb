class SettingSerializer < ActiveModel::Serializer
  attributes :id, :welcome_message, :no_of_order_to_send_growth_sms, :no_of_days_to_send_lapse_message
  has_one :retailer
end
