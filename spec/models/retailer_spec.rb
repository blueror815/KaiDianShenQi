require 'spec_helper'

describe Retailer do
  context "user_name and password for a retailer" do
    before { @retailer = FactoryGirl.build(:retailer) }
    subject { @retailer }
    it { should respond_to(:user_name) }
    it { should respond_to(:password) }
    it { should respond_to(:password_confirmation) }

    it { should validate_presence_of(:user_name) }
    it { should validate_uniqueness_of(:user_name) }
    it { should validate_confirmation_of(:password) }
    it { should validate_length_of(:password).is_at_least(8)}
    it { should validate_presence_of(:password) }

    it { should be_valid }

    it { should have_many :products}
    it { should have_many :orders}
    it { should have_many :memberships}
    it { should have_many(:members).through(:memberships)}
    it { should have_many :awards}

    it { should respond_to(:auth_token)}
    it { should validate_uniqueness_of(:auth_token)}

    describe "#generate_authentication_token!" do
      it "generates a unique token" do
        allow(Devise).to receive(:friendly_token).and_return("auniquetoken123")
        @retailer.generate_retailer_authentication_token!
        expect(@retailer.auth_token).to eql "auniquetoken123"
      end

      it "generates another token when one already has been taken" do
        existing_retailer = FactoryGirl.create(:retailer, auth_token: "auniquetoken123")
        @retailer.generate_retailer_authentication_token!
        expect(@retailer.auth_token).not_to eql existing_retailer.auth_token
      end
    end
  end

  context "Methods" do
    let!(:retailer2){ FactoryGirl.create(:retailer) }
    let!(:member){ FactoryGirl.create(:member) }
    let!(:new_member){ FactoryGirl.create(:member, member_external_id: '222-333-444') }
    let!(:membership){ FactoryGirl.create :membership, {retailer_id: retailer2.id, member_id: member.id} }

    describe "Add points" do
      it "adds member to membership if he is not in membership already" do
        expect{
          retailer2.add_points_to_member!(10, new_member.member_external_id)
        }.to change{
          retailer2.memberships.count
        }.by 1
      end

      it "add points to member" do
        retailer2.add_points_to_member!( 10, member.member_external_id)
        # after adding the points, need to reload this membership for testing since the one in memory was old
        membership.reload
        expect(membership.points).to be(20)
      end

      it "notifies members with sms when closes product to his point level is not avaialble" do
        SMS::OneInfo.stub(:delay).and_return(SMS::OneInfo)
        expect(SMS::OneInfo).to receive(:send_text).with( "您刚刚在店家【#{retailer2.user_name}】获得10点积分。店家正在筹备兑换计划，敬请关注。~萌萌哒~",
            member.member_external_id )
        retailer2.add_points_to_member!( 10, member.member_external_id)
         
      end

      it "notifies members with available rewards to redeem (enough points)" do
        product = FactoryGirl.create(:product, retailer: retailer2, point_value: 5)

        SMS::OneInfo.stub(:delay).and_return(SMS::OneInfo)
        SMS::OneInfo.should_receive(:send_text).with( "您刚刚在店家【" + retailer2.user_name + "】消费并积分" + '10点。' + "已可以兑换{" + product.title + "}等赠品",
            member.member_external_id )
        retailer2.add_points_to_member!( 10, member.member_external_id)
      end

      it "notifies members with sms when closes product to his point level is avaialble (not enough points)" do
        product = FactoryGirl.create(:product, retailer: retailer2, point_value: 100)
        SMS::OneInfo.stub(:delay).and_return(SMS::OneInfo)
        SMS::OneInfo.should_receive(:send_text).with( "您刚刚在店家【" + retailer2.user_name + "】消费并积分" + '10点。' + "再积分80即可兑换" + product.title,
                                                      member.member_external_id )
        retailer2.add_points_to_member!( 10, member.member_external_id)
      end

    end
  end
end
