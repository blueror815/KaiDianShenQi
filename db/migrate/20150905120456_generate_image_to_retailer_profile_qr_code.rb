class GenerateImageToRetailerProfileQrCode < ActiveRecord::Migration
  def change
    Retailer.all.each do |ret|
      ret.generate_profile_qr_image unless ret.profile_qr_image.exists?
     end
  end
end
