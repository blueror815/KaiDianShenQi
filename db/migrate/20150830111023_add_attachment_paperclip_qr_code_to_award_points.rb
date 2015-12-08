class AddAttachmentPaperclipQrCodeToAwardPoints < ActiveRecord::Migration
  def self.up
    change_table :award_points do |t|
      t.attachment :qr_code
    end
  end

  def self.down
    remove_attachment :award_points, :qr_code
  end
end
