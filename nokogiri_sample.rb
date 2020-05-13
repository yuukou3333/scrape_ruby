require 'nokogiri'

html = File.open('pitnews.html', 'r') { |f| f.read }
doc = Nokogiri::HTML.parse(html, nil, 'utf-b')

nodes = doc.xpath('//h6')
nodes.each { |node| pp node }
