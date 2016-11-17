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
    visionLabels
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
  
end
