class Api::V1::MemberSessionsController < ApplicationController
  def create
    user_password = params[:session][:password]
    member_external_id = params[:session][:member_external_id]

    member = Member.find_by(member_external_id: member_external_id)

    if member_external_id.present? && !member.nil? && member.valid_password?(user_password)
      sign_in member, store: false
      member.generate_member_authentication_token!
      member.save!
      render json: member, status: 200
    else
      render json: { errors: "Invalid user_name or password" }, status: 422
    end
  end

  def destroy
    member = Member.find_by(auth_token: params[:id])
    member.generate_member_authentication_token!
    member.save
    head 204
  end


end
