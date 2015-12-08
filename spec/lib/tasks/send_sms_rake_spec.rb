describe "send_sms:first_visit" do
  include_context "rake"
  
  let!(:retailer){FactoryGirl.create(:retailer)}
  let!(:membership){FactoryGirl.create(:membership, retailer: retailer)}

  its(:prerequisites) { should include("environment") }

  it "sends first visit sms to the user who is 15 mints or more old" do
    membership.update_attribute(:created_at, 16.minutes.ago)
    subject.invoke
    expect(membership.sms_first_visit).to_not be nil
  end

  it "sends does not sent first visit sms to the user who is less then 15 mints or more old" do
    membership.update_attribute(:created_at, 10.minutes.ago)
    subject.invoke
    expect(membership.sms_first_visit).to be nil
  end

  it "sends first visit sms to all users who are more then 15 mints old" do
    eligible_members = Array.new
    5.times do
      eligible_members << FactoryGirl.create(:membership, created_at: (15 + rand(0..2) ).minutes.ago)
    end
 
    new_membership = FactoryGirl.create(:membership, created_at: 10.minutes.ago)
    subject.invoke

    eligible_members.each do |eligible_member|
      expect(eligible_member.sms_first_visit).to_not be nil
    end
  end

  it "doesn't send sms to any membership to whom sms has already been sent" do
    membership.update_attribute(:created_at, 16.minutes.ago)
    FactoryGirl.create(:sms_first_visit, membership: membership)

    expect{
      subject.invoke
    }.to change{
      SmsFirstVisit.where(membership: membership).count
    }.by 0 
  end
end

describe "send_sms:growth_visit" do
  include_context "rake"

  let!(:retailer){FactoryGirl.create(:retailer)}
  let!(:membership){FactoryGirl.create(:membership, created_at: 16.minutes.ago, retailer: retailer)}
  
  it "does not creates sms growth visit record in first run" do
    expect{
      subject.invoke
    }.to change{
      membership.sms_growth_visits.count
    }.by 0
  end
 
  it "sends sms on more then configured orders" do
    3.times do
      FactoryGirl.create(:order, retailer: retailer, member: membership.member)
    end
    expect{
      subject.invoke
    }.to change{
      membership.sms_growth_visits.count
    }.by 1
  end 
end

describe "send_sms:lapse_visit" do
  include_context "rake"

  let!(:retailer){FactoryGirl.create(:retailer)}
  let!(:membership){FactoryGirl.create(:membership, created_at: 16.minutes.ago, retailer: retailer)}

  it "does not send sms risk notification in first run" do
    expect{
      subject.invoke
    }.to change{
      membership.sms_risk_notifications.count
    }.by 0
  end

  it "sends sms risk notification if order placed before configured days" do     
    membership.update_attribute(:created_at, retailer.setting.no_of_days_to_send_lapse_message.to_i.days.ago)
    previous_order = FactoryGirl.create(:order, retailer: retailer, member: membership.member, 
      created_at: retailer.setting.no_of_days_to_send_lapse_message.to_i.days.ago)

    expect{
      subject.invoke
    }.to change{
      membership.sms_risk_notifications.count
    }.by 1
  end
  
  
end
