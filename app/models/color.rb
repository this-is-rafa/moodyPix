class Color < ApplicationRecord
  belongs_to :picture

 	def self.store_colors_primary(rgbs, scores, id)
	  rgbs.each_with_index do |rgb, i|
	  	color = new

	  	r = rgb["red"]
        g = rgb["green"]
        b = rgb["blue"]
	    color.rgb = "rgb(#{r},#{g},#{b})"

	    shade1_percent = 0.4
        r_shade1 = rgb["red"].to_f
        g_shade1 = rgb["green"].to_f
        b_shade1 = rgb["blue"].to_f
        r_shade1 = (r_shade1 * shade1_percent).to_i
        g_shade1 = (g_shade1 * shade1_percent).to_i
        b_shade1 = (b_shade1 * shade1_percent).to_i
        color.shade1 = "rgb(#{r_shade1},#{g_shade1},#{b_shade1})"

        shade2_percent = 0.7
        r_shade2 = rgb["red"].to_f
        g_shade2 = rgb["green"].to_f
        b_shade2 = rgb["blue"].to_f
        r_shade2 = (r_shade2 * shade2_percent).to_i
        g_shade2 = (g_shade2 * shade2_percent).to_i
        b_shade2 = (b_shade2 * shade2_percent).to_i
        color.shade2 = "rgb(#{r_shade2},#{g_shade2},#{b_shade2})"

        shade3_percent = 1.4
        r_shade3 = rgb["red"].to_f
        g_shade3 = rgb["green"].to_f
        b_shade3 = rgb["blue"].to_f
        r_shade3 = (r_shade3 * shade3_percent).to_i
        g_shade3 = (g_shade3 * shade3_percent).to_i
        b_shade3 = (b_shade3 * shade3_percent).to_i
        color.shade3 = "rgb(#{r_shade3},#{g_shade3},#{b_shade3})"

        tint1_percent = 0.4
     	r_tint1 = rgb["red"].to_f
     	g_tint1 = rgb["green"].to_f
        b_tint1 = rgb["blue"].to_f
        r_tint1 = ((255-r_tint1) * tint1_percent).to_i
        g_tint1 = ((255-g_tint1) * tint1_percent).to_i
        b_tint1 = ((255-b_tint1) * tint1_percent).to_i
        color.tint1 = "rgb(#{r_tint1},#{g_tint1},#{b_tint1})"

        tint2_percent = 0.7
     	r_tint2 = rgb["red"].to_f
     	g_tint2 = rgb["green"].to_f
        b_tint2 = rgb["blue"].to_f
        r_tint2 = ((255-r_tint2) * tint2_percent).to_i
        g_tint2 = ((255-g_tint2) * tint2_percent).to_i
        b_tint2 = ((255-b_tint2) * tint2_percent).to_i
        color.tint2 = "rgb(#{r_tint2},#{g_tint2},#{b_tint2})"

        tint3_percent = 1.4
     	r_tint3 = rgb["red"].to_f
     	g_tint3 = rgb["green"].to_f
        b_tint3 = rgb["blue"].to_f
        r_tint3 = ((255-r_tint3) * tint3_percent).to_i
        g_tint3 = ((255-g_tint3) * tint3_percent).to_i
        b_tint3 = ((255-b_tint3) * tint3_percent).to_i
        color.tint3 = "rgb(#{r_tint3},#{g_tint3},#{b_tint3})"

        color.score = scores[i]
        color.picture_id = id

        color.save!
      end
   end
end
