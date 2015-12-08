class Api::V1::RetailersController < ApplicationController
  before_action :authenticate_with_token!, only: [:show, :find_and_show_membership, :add_points_to_member, :show_sign_up]
  respond_to :json

  def show
    if params[:id] == current_oauth_retailer.id.to_s
      render json: current_oauth_retailer, status: 200
    else
      render json: {errors: "Not authorized"}, status:422
    end
  end

  def show_sign_up
    render json: current_oauth_retailer.sign_up_progress.show_sign_up, status: 200
  end

  def find_and_show_membership
    member = Member.find_by_member_external_id params[:member_external_id]
    if member.nil?
      render json: {errors: "This member_external_id doesn't exist"}, status: 422, format: :json
    else
      membership = current_oauth_retailer.memberships.find_by_member_id member[:id]
      if membership.nil?
        membership = Membership.create(member: member, retailer: current_oauth_retailer)
      end
      render json: membership, status: 200, format: :json
    end
  end


  def add_points_to_member
    add_result = current_oauth_retailer.add_points_to_member!(params[:add_points].to_f, params[:member_external_id])
    if add_result.is_a?(Hash)
      render json: add_result, status: 422
    else

      render json: add_result, status: 201
    end
  end

  def create
    retailer = Retailer.new(retailers_params)
    if retailer.save
      render json: retailer, status: 201, location: [:api, retailer]
    else
      render json: {errors: retailer.errors}, status: 422
    end
  end

  def profile_qr_image
    render json: {url: current_oauth_retailer.profile_qr_image.url}
  end

  private
  def retailers_params
    params.require(:retailer).permit(:user_name, :password, :password_confirmation)
  end
end
