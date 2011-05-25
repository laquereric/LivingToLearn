class SiteContent < ActiveRecord::Base
 
  has_attached_file :image, :styles => { :medium => ["300x300>",:png], :thumb => ["100x100>",:png] }

  private

end

