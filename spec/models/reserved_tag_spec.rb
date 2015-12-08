require 'rails_helper'

RSpec.describe ReservedTag, type: :model do
  it {should validate_presence_of :name}
end
