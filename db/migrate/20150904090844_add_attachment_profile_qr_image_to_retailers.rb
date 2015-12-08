class AddAttachmentProfileQrImageToRetailers < ActiveRecord::Migration
  def self.up
    change_table :retailers do |t|
      t.attachment :profile_qr_image
    end
  end

  def self.down
    remove_attachment :retailers, :profile_qr_image
  end
end
