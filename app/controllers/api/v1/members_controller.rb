#encoding: utf-8
require 'sms'
include SMS

class Api::V1::MembersController < ApplicationController
  respond_to :json
  before_action :authenticate_with_token_member!, only: [:show_my_retailers]

  def create
    member =  Member.new(member_params)

    if member.save
      # currently use this template
      render json: member, status: 201
    else
      render json: {errors: member.errors}, status: 422
    end
  end

  def show_my_retailers
    member = Member.find_by_member_external_id params[:member_external_id]
    if member.nil? 
      render json: nil, status: 404, format: :json
    else
      render json: member, status: 200, format: :json
    end
  end


  def associate_client_id
    member = Member.find_by_member_external_id params[:member_external_id]
    if member.nil?
      render json: nil, status: 404, format: :json
    else
      client_id = params[:client_id]
      member.associate_client_id(client_id)
      render json: member, status: 200, format: :json
    end
  end

  def destroy_client_id
    member = Member.find_by_member_external_id params[:member_external_id]
    if member.nil?
      render json: nil, status: 404, format: :json
    else
      member.destroy_client_id
      render json: member, status: 200, format: :json
    end
  end


  private
  def member_params
    params.require(:member).permit(:member_external_id, :address, :gender, :birth_date, :password, :password_confirmation)
  end

end
