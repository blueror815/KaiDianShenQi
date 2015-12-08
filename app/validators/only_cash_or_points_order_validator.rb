
class OnlyCashOrPointsOrderValidator < ActiveModel::Validator
  def validate(record)
    if record.total_charge == 0 || record.total_points_charge == 0
      true
    else
      record.errors[:order] << "total_charge and total_points_charge can't be larger than 0 at the same time"
      false
    end
  end
end