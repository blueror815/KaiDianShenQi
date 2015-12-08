class SignUpProgress < ActiveRecord::Base
  belongs_to :retailer

  def show_sign_up
    #if updated_at.to_i -     days_since_last_order = (Time.now - last_visit_time).to_i / 86400
    days_since_update = (Time.now - updated_at).to_i / 86400
    if days_since_update > self.refresh_sign_up_every_days
      # now we should refresh
      if self.sign_up_so_far >= self.sign_up_goal
        message = self.retailer.user_name + " achieved the goal " + self.sign_up_so_far.to_s + "/" + self.sign_up_goal.to_s
      else
        message = self.retailer.user_name + "did not achieved the goal " + self.sign_up_so_far.to_s + "/" + self.sign_up_goal.to_s
      end

      # Send this to our numbers
      SMS::OneInfo.send_text(
          message, "18612490818"
      ).delay

      SMS::OneInfo.send_text(
          message, "15001131183"
      ).delay

      # refresh for real
      self.sign_up_so_far = 0
      self.save #this will change the updated_at field
    end

    self
  end
end
