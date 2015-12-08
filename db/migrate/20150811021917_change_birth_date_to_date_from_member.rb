class ChangeBirthDateToDateFromMember < ActiveRecord::Migration
  def change
    #change_column :members, :birth_date, :date, 'birth_date USING CAST(birth_date AS date)'
  end
end
