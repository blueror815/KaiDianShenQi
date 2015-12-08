class SettingsController < ApplicationController
  before_action :set_setting, only: [:edit, :update]
  before_filter :authenticate_retailer!

  # GET /settings/1/edit
  def edit
  end

  # PATCH/PUT /settings/1
  def update
    if @setting.update(setting_params)
      redirect_to edit_setting_path(@setting), notice: 'Setting was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = current_owner.setting
    end

    # Only allow a trusted parameter "white list" through.
    def setting_params
      params.require(:setting).permit(:welcome_message, :growth_message, :risk_message, :no_of_order_to_send_growth_sms, 
        :no_of_days_to_send_lapse_message, :test_promotion_contact_no, :qr_image)
    end
end
