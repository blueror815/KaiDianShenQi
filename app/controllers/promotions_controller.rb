class PromotionsController < ApplicationController
  before_action :set_promotion, only: [:edit, :update]
  before_filter :authenticate_retailer!
  layout 'promotion'

  # GET /promotions
  def index
    @promotions = current_owner.promotions
    if @promotions.length == 0
      @tags = current_owner.memberships.collect(&:tags).flatten
      @promotion = Promotion.new
      render action: :new
    else
      render
    end
  end

  # GET /promotions/1
  def show
  end

  # GET /promotions/new
  def new
    @promotion = Promotion.new
    @tags = current_owner.memberships.collect(&:tags).flatten
  end

  # POST /promotions
  def create
    @promotion = Promotion.new(promotion_params)
    @promotion.retailer = current_owner

    if @promotion.save
      if params[:member_types].class == Array
        params[:member_types].each do |member_type|
          #Each promotion tag shall send sms to all the memberships of having that tag
          @promotion.promotion_tags.create(tag: member_type)
        end
      end
      redirect_to promotions_path, notice: 'Promotion was successfully created.'
    else
      @tags = current_owner.memberships.collect(&:tags).flatten
      render :new
    end
  end

  def test_sms
    SMS::OneInfo.send_text(params[:message], params[:mobile_no]).delay
    render json: {status: 'success'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def promotion_params
      params.require(:promotion).permit(:retailer_id, :offer, :occation, :expiry_date, :tags)
    end
end
