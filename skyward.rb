# frozen_string_literal: true

require 'fileutils'
require 'nokogiri'
require_relative './methods'

FileUtils.mkdir_p('skyward')

BASE = 'https://www.getunderlined.com'

links = [
  '/read/excerpt-reveal-start-reading-skyward-by-brandon-sanderson/'
]

episode = 1
links.each do |link|
  url = BASE + link
  puts "Download #{url}"
  `curl --silent "#{url}" --output "skyward/#{episode}.html"` unless File.exist? "skyward/#{episode}.html"
  episode += 1
end

html = '<title>Skyward</title>'
(1..(links.length)).each do |i|
  complete_html = Nokogiri::HTML(open("skyward/#{i}.html"))
  page = complete_html.css('article')[0]
  html += page.inner_html
end

File.open('books/skyward.html', 'w') { |file| file.write(html) }
puts '[html] Generated HTML file'

generate('skyward', :all)
