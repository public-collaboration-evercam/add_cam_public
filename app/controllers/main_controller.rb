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
        title: info,
        external_host: get_host_port(ip_port, 0),
        external_http_port: get_host_port(ip_port, 1),
        vendor: "axis",
        name: "#{info.partition(" ").last.partition(" ").last.partition(" ").last.split(",")[0]}",
        api_id: "#{ENV['USER_API_ID']}",
        api_key: "#{ENV['USER_API_KEY']}"
      }
    end
    render json: @records.to_json
  end

  def get_host_port(ip_port, value)
    val = ip_port.split("/")
    new_val = val[2].split(":")
    new_val[value]
  end
end
