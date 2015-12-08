module PromotionHelper
  def user_count tag_collection, tag
    tag_collection.count(tag)
  end
end
