class RetailersController < ApplicationController

  def show
    @open_id = retrive_open_id(params[:code])
    award = Award.find_by_open_id @open_id

    @phone_number = award.try('phone_number')
    @retailer = Retailer.find params[:id]

    # Now post to node.js and node.js will notify retailer's phone
    RestClient.post("http://localhost:8001", {"retailer_id" => @retailer.id, "customer_id"=> @phone_number, "token" => "7ff8ddd4-35d6-405f-ba6b-a594124a91aa"}.to_json, "Content-Type" => "application/json")
    
    render layout: 'jmobile'
  end
end
