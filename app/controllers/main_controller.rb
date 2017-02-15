class MainController < ApplicationController
  require 'nokogiri'
  require 'open-uri'

  def index
    
  end

  def load_cameras_details
    page_number = params[:page_number]
    page = Nokogiri::HTML(open("http://www.insecam.org/en/bytype/axis/?page=#{page_number}"))
    search_node = page.search(".thumbnail-item__img")
    get_camera = search_node.map {|element| element["src"]}.compact
    get_camera_info = search_node.map {|element| element["title"]}.compact
    total_records = get_camera.count
    mixing = get_camera.zip get_camera_info
    @records = mixing.map do |ip_port, info|
      {
        image_url: ip_port,
        title: info
      }
    end
    render json: @records.to_json
  end
end
