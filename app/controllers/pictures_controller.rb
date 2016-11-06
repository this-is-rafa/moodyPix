require "base64"
require 'net/http'
require 'json'
require 'open-uri'

class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]

  # GET /pictures
  # GET /pictures.json
  def index
    @pictures = Picture.all
    @picture = Picture.new
  end

  # GET /pictures/1
  # GET /pictures/1.json
  def show
    @review = Review.new

    download = open(@picture.url)
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

    detected_text = ""
    res.start do |http| 
      # puts "Querying Google for image: #{@picture}"
      resp = http.request(req)
      
      @json = JSON.parse(resp.body)

      @labels = @json["responses"][0]["labelAnnotations"]
      @colors = @json["responses"][0]["imagePropertiesAnnotation"]["dominantColors"]["colors"]

      if @json && @json["responses"] && @json["responses"][0]["faceAnnotations"]
        @face_mood = @json["responses"][0]["faceAnnotations"][0]
      end

      if @json && @json["responses"] && @json["responses"][0]["textAnnotations"] && @json["responses"][0]["textAnnotations"][0]["description"]
        @detected_text = @json["responses"][0]["textAnnotations"][0]["description"]
      end
    end

  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)

    respond_to do |format|
      if @picture.save
        format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
        format.json { render :show, status: :created, location: @picture }
      else
        format.html { render :new }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:title, :url)
    end
end