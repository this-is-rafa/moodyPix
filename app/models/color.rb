class Color < ApplicationRecord
  belongs_to :picture

 	def self.build_from_google_vision(rgbs, scores, id)
 		color = new
 		color.rgb1 = rgbs[0]
 		color.rgb2 = rgbs[1]
 		color.rgb3 = rgbs[2]
 		color.rgb4 = rgbs[3]
 		color.rgb5 = rgbs[4]
 		color.rgb6 = rgbs[5]
 		color.rgb7 = rgbs[6]
 		color.rgb8 = rgbs[7]
 		color.rgb9 = rgbs[8]
 		color.rgb10 = rgbs[9]
 		color.score1 = scores[0]
 		color.score2 = scores[1]
 		color.score3 = scores[2]
 		color.score4 = scores[3]
 		color.score5 = scores[4]
 		color.score6 = scores[5]
 		color.score7 = scores[6]
 		color.score8 = scores[7]
 		color.score9 = scores[8]
 		color.score10 = scores[9]
 		color.picture_id = id
 		color.save!
 	end

end
