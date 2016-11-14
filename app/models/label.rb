class Label < ApplicationRecord
  belongs_to :picture

  def self.store_labels(descriptions, scores, id)
	  descriptions.each_with_index do |des, i|
	  	label = new
	  	label.description = des
	  	label.score = scores[i].to_i
	  	label.picture_id = id
	  	label.save!
	  end	  
	  
 	end

end
