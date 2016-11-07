class Picture < ApplicationRecord
  has_many :reviews

  attr_reader :label_descriptions, :label_scores, :color_rgb_strings, :color_scores, :detected_text, :face_mood, :joy, :sorrow, :anger, :surprise

  def googleVision(picture)

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
                "maxResults": 10
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
      # convert RGB hashes to strings to use for HTML rgb(r,g,b) color values
      @color_rgb_strings = []
      @color_rgb.each do |rgb|
        r = rgb["red"]
        g = rgb["green"]
        b = rgb["blue"]
        @color_rgb_strings << "rgb(#{r},#{g},#{b})"
      end
    end

    # Extract and parse faceAnnotations portion of JSON response
    def visionFace
      if @json && @json["responses"] && @json["responses"][0]["faceAnnotations"]
      @face_mood = @json["responses"][0]["faceAnnotations"][0]
      @joy = @face_mood["joyLikelihood"]
      @sorrow = @face_mood["sorrowLikelihood"]
      @anger = @face_mood["angerLikelihood"]
      @surpirse = @face_mood["surpriseLikelihood"]
      end
    end

  def visionText
    if @json && @json["responses"] && @json["responses"][0]["textAnnotations"] && @json["responses"][0]["textAnnotations"][0]["description"]
      @detected_text = @json["responses"][0]["textAnnotations"][0]["description"]
    end
  end
end
	