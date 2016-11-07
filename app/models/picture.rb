class Picture < ApplicationRecord
  has_many :reviews

  attr_reader :labeldescriptions, :labelscores, :color_rgb_strings_primary, :color_rgb, :colorScores, :detected_text, :face_mood, :joy, :sorrow, :anger, :surprise, :color_rgb_strings_primary, :color_rgb_strings_shade1, :color_rgb_strings_shade2, :color_rgb_strings_light1, :color_rgb_strings_light2, :color_rgb_strings_opposites

  def googleVision

    download = open(self.url)
    # IO.copy_stream(download, '~/image.png')

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

    colors.each do |color|
      @colorRGBs << color["color"]
      @colorScores << color["score"] * 100
    end

    # Find aggregare value of color scores and stretch to 100 if necessary
    color_percent = 0
    @colorScores.each { |a| color_percent+=a }
    if color_percent < 100 
      percent_diff = (100 - color_percent)
      @colorScores.map do |score|
        score = (score + (percent_diff/10))
      end
    end

  end

  # convert RGB hashes to strings to use for HTML rgb(r,g,b) color values
  def colorsPrimary
    @color_rgb_strings_primary = []
    @colorRGBs.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      @color_rgb_strings_primary << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade1
    @color_rgb_strings_shade1 = []
    shade_percent = 0.15
    @colorRGBs.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (r * shade_percent).to_i
      g = (g * shade_percent).to_i
      b = (b * shade_percent).to_i
      @color_rgb_strings_shade1 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade2
    @color_rgb_strings_shade2 = []
    shade_percent = 0.30
    @colorRGBs.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (r * shade_percent).to_i
      g = (g * shade_percent).to_i
      b = (b * shade_percent).to_i
      @color_rgb_strings_shade2 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsLight1
    @color_rgb_strings_light1 = []
    light_percent = 1.15
    @colorRGBs.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (r * light_percent).to_i
      g = (g * light_percent).to_i
      b = (b * light_percent).to_i
      @color_rgb_strings_light1 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsLight2
    @color_rgb_strings_light2 = []
    light_percent = 1.30
    @colorRGBs.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (r * light_percent).to_i
      g = (g * light_percent).to_i
      b = (b * light_percent).to_i
      @color_rgb_strings_light2 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsOpposites
    @color_rgb_strings_opposites = []
    @colorRGBs.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (255-r).to_i
      g = (255-g).to_i
      b = (255-b).to_i
      @color_rgb_strings_opposites << "rgb(#{r},#{g},#{b})"
    end
  end

  # Extract and parse labelAnnotations portion of JSON response
  def visionLabels
    labels = @json["responses"][0]["labelAnnotations"]
    @labeldescriptions = []
    @labelscores = []
    labels.each do |label|
      @labeldescriptions << label["description"]
      @labelscores << label["score"] * 100
    end
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