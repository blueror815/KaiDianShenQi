require 'rails_helper'

RSpec.describe PromotedOrder, type: :model do
  it {should validate_presence_of :promotion_id}
  it {should validate_presence_of :order_id}

  it {should belong_to :promotion}
  it {should belong_to :order}
end
