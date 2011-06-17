require 'mechanize'
require 'jd-control'

jd_control = JDownloader::Control.new
agent = Mechanize.new

page = agent.get("http://nobrasil.org/1001-discos-para-ouvir-antes-de-morrer/")

album_pages_links = []
albums = []

page.links_with(:text => /download/).each do |link|
  album_pages_links << link.href
end

# Get until 1000. The others are extras.
album_pages_links[0..1000].each do |album_page_link|
  album_page = agent.get(album_page_link)
  album_page_post_title = album_page.search(".post > .post-title > a").text
  mechanize_download_links = album_page.links_with(:href => /(rapidshare|easy-share|megaupload)/)

  raw_download_links = []
  mechanize_download_links.each do |link|
    raw_download_links << link.href
  end
  
  ranking = 
  artist = /(.+\..)(.+)\|/.match(album_page_post_title)[2].strip
  title = /\|.(.+)/.match(album_page_post_title)[1].strip
  album = {:artist => artist, :title => title, :download_links => raw_download_links}
  albums << album   

  raw_download_links.each do |link|
    jd_control.add_link(link)
  end

  puts "\nPegou:\n "
  y album
end






