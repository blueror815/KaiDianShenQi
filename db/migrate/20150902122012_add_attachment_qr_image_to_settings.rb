class AddAttachmentQrImageToSettings < ActiveRecord::Migration
  def self.up
    change_table :settings do |t|
      t.attachment :qr_image
    end
  end

  def self.down
    remove_attachment :settings, :qr_image
  end
end
