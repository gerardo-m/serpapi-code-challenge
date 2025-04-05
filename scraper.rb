require 'nokogiri'
require 'ferrum'

class Scraper

  HOST = "https://www.google.com"
  DEFAULT_FILE = "./files/van-gogh-paintings.html"

  def initialize(file_path=DEFAULT_FILE)
    @file_path = file_path
  end

  def perform
    file = File.new(@file_path)
    result = {}
    result["artworks"] = []
    browser = Ferrum::Browser.new
    browser.goto("file:///#{File.expand_path(file)}")
    browser.network.wait_for_idle
    document = Nokogiri::HTML(browser.body)
    image_section = document.search("div.Cz5hV > div")
    image_section.each do |image_item|
      artwork = process_section(image_item)
      result["artworks"] << artwork
    end
    browser.quit
    result
  end

  private def process_section(image_item)
    artwork = {}
    artwork["name"] = image_item.search("div.pgNMRc").text
    extensions = image_item.search("div.KHK6lb > div")
    extensions = extensions.slice(1, extensions.count)
    extensions_array = []
    extensions.each do |ext|
      extensions_array << ext.text unless ext.text.empty?
    end  
    artwork["extensions"] = extensions_array unless extensions_array.empty?    
    artwork["link"] = "#{HOST}#{image_item.search("a").attribute("href").value}"
    image_attr = image_item.search("a > img.taFZJe").attribute("data-src")
    image_attr ||= image_item.search("a > img.taFZJe").attribute("src")
    artwork["image"] = image_attr.value
    artwork
  end
end