class Picture < ApplicationRecord
  has_many :reviews
  has_many :colors
  has_many :labels

  attr_reader :labeldescriptions, :labelscores, :color_rgb_strings_primary, :color_rgb, :colorScores, :detected_text, :face_mood, :joy, :sorrow, :anger, :surprise, :color_rgb_strings_primary, :color_rgb_strings_shade1, :color_rgb_strings_shade2, :color_rgb_strings_shade3, :color_rgb_strings_tint1, :color_rgb_strings_tint2, :color_rgb_strings_tint3

  def image_analysis
    #call Google Vision API method in picture.rb model...
    googleVision
    #call parsing methods to extract useful data from API response...    
    visionColors
    colorsPrimary
    colorsShade1
    colorsShade2
    colorsShade3
    colorsTint1
    colorsTint2
    colorsTint3
    visionLabels
    visionFace
    visionText
  end

  def googleVision
    download = open(self.url)

    # Base 64 the input image
    b64_image = Base64.encode64(download.read)

    # Stuff we need
    api_key = ENV["GOOGLE_VISION_API_KEY"]
    content_type = "Content-Type: application/json"
    url = "https://vision.googleapis.com/v1/images:annotate?key=#{api_key}"
    data = {
        "requests": [
          {
            "image": {
              "content": b64_image
            },
            "features": [
              {
                "type": "LABEL_DETECTION",
                "maxResults": 20
              },
              {
                "type": "IMAGE_PROPERTIES",
                "maxResults": 10
              },
              {
                "type": "FACE_DETECTION",
                "maxResults": 10
              },
              {
                "type": "TEXT_DETECTION",
                "maxResults": 10
              }           
            ]
          }
        ]
      }.to_json

      # Make the request
      url = URI(url)
      req = Net::HTTP::Post.new(url, initheader = {'Content-Type' =>'application/json'})
      req.body = data
      res = Net::HTTP.new(url.host, url.port)
      res.use_ssl = true

      # res.set_debug_output $stderr

      res.start do |http| 
        resp = http.request(req)
        @json = JSON.parse(resp.body)
      end      
  end

  # Extract and parse imagePropertiesAnnotation portion of JSON response
  def visionColors
    colors = @json["responses"][0]["imagePropertiesAnnotation"]["dominantColors"]["colors"]
    @colorRGBs = []
    @colorScores = []

    colors.each_with_index do |color, i|
      # @colors[i] << color["color"]
      @colorRGBs << color["color"]
      @colorScores << color["score"] * 100
    end

    # Find aggregare value of color scores and stretch to 100 if necessary
    color_percent = 0
    @colorScores.each { |a| color_percent+=a }

    if color_percent < 100 
      percent_diff = (100 - color_percent)
      @colorScores.map! do |score|
        score += (percent_diff/10)
      end
    end

    # Call Color class method to shove RGB and score values into colors table
    Color.store_colors_primary(@colorRGBs, @colorScores, self.id)
 
   end

  # convert RGB hashes to strings to use for HTML rgb(r,g,b) color values
  def colorsPrimary
    @color_rgb_strings_primary = []
    self.colors.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      @color_rgb_strings_primary << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade1
    @color_rgb_strings_shade1 = []
    shade_percent = 0.4
    self.colors.each do |rgb|
      r = rgb["red"].to_f
      g = rgb["green"].to_f
      b = rgb["blue"].to_f
      r = (r*shade_percent).to_i
      g = (g*shade_percent).to_i
      b = (b*shade_percent).to_i
      @color_rgb_strings_shade1 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade2
    @color_rgb_strings_shade2 = []
    shade_percent = 0.6
    self.colors.each do |rgb|
      r = rgb["red"].to_f
      g = rgb["green"].to_f
      b = rgb["blue"].to_f
      r = (r*shade_percent).to_i
      g = (g*shade_percent).to_i
      b = (b*shade_percent).to_i
      @color_rgb_strings_shade2 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade3
    @color_rgb_strings_shade3 = []
    shade_percent = 1.5
    self.colors.each do |rgb|
      r = rgb["red"].to_f
      g = rgb["green"].to_f
      b = rgb["blue"].to_f
      r = (r*shade_percent).to_i
      g = (g*shade_percent).to_i
      b = (b*shade_percent).to_i
      @color_rgb_strings_shade3 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsTint1
    @color_rgb_strings_tint1 = []
    tint_percent = 0.4
    self.colors.each do |rgb|
      r = rgb["red"].to_f
      g = rgb["green"].to_f
      b = rgb["blue"].to_f
      r = ((255-r)*tint_percent).to_i
      g = ((255-g)*tint_percent).to_i
      b = ((255-b)*tint_percent).to_i
      @color_rgb_strings_tint1 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsTint2
    @color_rgb_strings_tint2 = []
    tint_percent = 0.6
    self.colors.each do |rgb|
      r = rgb["red"].to_f
      g = rgb["green"].to_f
      b = rgb["blue"].to_f
      r = ((255-r)*tint_percent).to_i
      g = ((255-g)*tint_percent).to_i
      b = ((255-b)*tint_percent).to_i
      @color_rgb_strings_tint2 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsTint3
    @color_rgb_strings_tint3 = []
    tint_percent = 1.5
    self.colors.each do |rgb|
      r = rgb["red"].to_f
      g = rgb["green"].to_f
      b = rgb["blue"].to_f
      r = ((255-r)*tint_percent).to_i
      g = ((255-g)*tint_percent).to_i
      b = ((255-b)*tint_percent).to_i
      @color_rgb_strings_tint3 << "rgb(#{r},#{g},#{b})"
    end
  end

  # Extract and parse labelAnnotations portion of JSON response
  def visionLabels
    labels = @json["responses"][0]["labelAnnotations"]
    @labeldescriptions = []
    @labelscores = []
    labels.each do |label|
      @labeldescriptions << label["description"]
      @labelscores << label["score"]*100
    end

    Label.store_labels(@labeldescriptions, @labelscores, self.id)
  end
  
  # Extract and parse faceAnnotations portion of JSON response
  def visionFace
    if @json && @json["responses"] && @json["responses"][0]["faceAnnotations"]
      @face_mood = @json["responses"][0]["faceAnnotations"][0]
      @joy = @face_mood["joyLikelihood"]
      @sorrow = @face_mood["sorrowLikelihood"]
      @anger = @face_mood["angerLikelihood"]
      @surprise = @face_mood["surpriseLikelihood"]
    end
  end

  def visionText
    if @json && @json["responses"] && @json["responses"][0]["textAnnotations"] && @json["responses"][0]["textAnnotations"][0]["description"]
      @detected_text = @json["responses"][0]["textAnnotations"][0]["description"]
    end
  end
end
