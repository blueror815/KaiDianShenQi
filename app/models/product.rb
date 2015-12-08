class Product < ActiveRecord::Base
  validates :title, :retailer_id, :price, presence: true
  validates :price, :presence => true, :numericality => { :greater_than_or_equal_to => 0.0}
  validates :point_value, :numericality => { :greater_than_or_equal_to => 0.0}
  audited

  belongs_to :retailer, :validate => true

  has_many :placements, dependent: :destroy
  has_many :orders, through: :placements, dependent: :destroy
end
