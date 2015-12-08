class MembersController < ApplicationController
  before_filter :authenticate_retailer!, except: [:award, :introduce]
  authorize_resource

  def introduce
    @open_id = retrive_open_id(params[:code])

    @award = Award.where(is_used: false).find_by_code params[:token]
    @award.update_attribute(:is_used, true) if @award

    previous_award = Award.find_by_open_id @open_id
    @phone_number = previous_award.phone_number if previous_award

    render layout: 'jmobile'
  end
  
  def award
    @award = Award.find params[:award_id]
    @award.update_attributes(
      open_id: params[:code],
      phone_number: params[:phone]
    )
    @award.update_membership_points(params[:member_external_id])

    render layout: 'jmobile'
  end

  def index
    @members = current_owner.members
    @memberships = current_owner.memberships.collect{|membership| {membership.member.id => membership.id}}.reduce({}, :merge)
    @tags = current_owner.memberships.collect(&:tag_list).flatten.uniq
  end

  def show
    @member = Member.find params[:id]
    @tags = @member.memberships.find_by_retailer_id(current_owner.id).tag_list
  end

  def add_tag
    membership = Membership.find_by(retailer_id: current_owner.id, member_id: params[:id])

    if params[:tag].to_s != ""
      reserved_tags = ReservedTag.all.collect(&:name)
      unless reserved_tags.include?(params[:tag])
        membership.tag_list.add(params[:tag])
        membership.save
      else
        @reserved_tag_block = true
      end
    end
    @tags = membership.tags.collect{|tag| "<div class='btn btn-mini btn-default'><span class='fa fa-tag'></span>#{tag}</div>&nbsp;"} 
  end

  def listing
    @memberships = current_owner.memberships.select{|membership| membership.tag_list.include?(params[:tag])}

    render layout: nil
  end


  def destroy
    @membership = Membership.find params[:id]
    @membership.destroy

    redirect_to members_path
  end
end
