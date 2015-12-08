describe "send an sms" do
  it "should be send sms to given number" do
    sms_details = SMS::OneInfo.send_text("sms-text", "sms-number")
    expect(sms_details.body).to eq "stubbed response"
  end
end
