require 'spec_helper'
require 'rails_helper'

describe SignUpProgress do
  describe "Sign up progress" do
    let(:sign_up_progress){FactoryGirl.create :sign_up_progress}
    subject {sign_up_progress}
    it {should respond_to :sign_up_goal}
    it {should respond_to :sign_up_so_far}
    it {should respond_to :refresh_sign_up_every_days}
    it {should belong_to :retailer }
  end

  before(:each) do
    @retailer = FactoryGirl.create :retailer
    @sign_up_info = FactoryGirl.create :sign_up_progress, {retailer: @retailer}
  end
  it "add a sign up whenever a membership is created for this retailer" do
    expect{
      120.times{FactoryGirl.create :membership, {retailer: @retailer}}
    }.to change{@retailer.sign_up_progress.sign_up_so_far}.by(120)
  end

  it "should refresh" do
    15.times{FactoryGirl.create :membership, {retailer: @retailer}}
    travel_to 10.days.from_now do
      @retailer.sign_up_progress.show_sign_up
      expect(@retailer.sign_up_progress.sign_up_so_far).to be 0
    end
  end
  it "should not refresh" do
    15.times{FactoryGirl.create :membership, {retailer: @retailer}}
    travel_to 6.days.from_now do
      @retailer.sign_up_progress.show_sign_up
      expect(@retailer.sign_up_progress.sign_up_so_far).to be 15
    end
  end
end

