class SaveGoogleVisionDataService
	def self.googleVision(picture)

	download = open(picture.url)
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

	# Extract and parse labelAnnotations portion of JSON response
  def visionLabels
    @labels = @json["responses"][0]["labelAnnotations"]
    @label_descriptions = []
    @label_scores = []
    @labels.each do |label|
      @label_descriptions << label["description"]
      @label_scores << label["score"] * 100
    end
  end

  # Extract and parse imagePropertiesAnnotation portion of JSON response
  def visionColors
    @colors = @json["responses"][0]["imagePropertiesAnnotation"]["dominantColors"]["colors"]
    @color_rgb = []
    @color_scores = []

    @colors.each do |color|
      @color_rgb << color["color"]
      @color_scores << color["score"] * 100
    end

    # Find aggregare value of color scores and stretch to 100 if necessary
    color_percent = 0
    @color_scores.each { |a| color_percent+=a }
    if color_percent < 100 
      percent_diff = (100 - color_percent)
      @color_scores.map do |score|
        score = (score + (percent_diff/10))
      end
    end
  end

  # convert RGB hashes to strings to use for HTML rgb(r,g,b) color values
  def colorsPrimary
    @color_rgb_strings_primary = []
    @color_rgb.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      @color_rgb_strings_primary << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade1
    @color_rgb_strings_shade1 = []
    @color_rgb.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (r * 0.25).to_i
      g = (g * 0.25).to_i
      b = (b * 0.25).to_i
      @color_rgb_strings_shade1 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsShade2
    @color_rgb_strings_shade2 = []
    @color_rgb.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = (r * 0.5).to_i
      g = (g * 0.5).to_i
      b = (b * 0.5).to_i
      @color_rgb_strings_shade2 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsTint1
    @color_rgb_strings_tint1 = []
    @color_rgb.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = ((255-r) * 0.25).to_i
      g = ((255-g) * 0.25).to_i
      b = ((255-b) * 0.25).to_i
      @color_rgb_strings_tint1 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsTint2
    @color_rgb_strings_tint2 = []
    @color_rgb.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = ((255-r) * 0.5).to_i
      g = ((255-g) * 0.5).to_i
      b = ((255-b) * 0.5).to_i
      @color_rgb_strings_tint2 << "rgb(#{r},#{g},#{b})"
    end
  end

  def colorsOpposites
    @color_rgb_strings_opposites = []
    @color_rgb.each do |rgb|
      r = rgb["red"]
      g = rgb["green"]
      b = rgb["blue"]
      r = ((255-r) * 0.5).to_i
      g = ((255-g) * 0.5).to_i
      b = ((255-b) * 0.5).to_i
      @color_rgb_strings_opposites << "rgb(#{r},#{g},#{b})"
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