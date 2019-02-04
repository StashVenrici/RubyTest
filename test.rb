#1
#require "open-uri"

#пример, как сохранить веб-страницу в файл
#web_date = open("http://google.com").read
#my_file = open("my-downloaded-page.html", "w")
#my_file.write(web_date)
#my_file.close

#сокращенная запись
#my_file2= open("page2.html", "w")
#my_file2.write(open("http://google.com").read)
#my_file2.close

#2 test scrapping wiki
# require 'rubygems'
# #require 'restclient' #incompatible??
# require 'rest-client'
# require 'crack'
# WURL = 'https://en.wikipedia.org/w/api.php?action=opensearch&format=json&formatversion=2&search='

# wiki_file = open("wiki.txt","w")

# ('A'..'C').to_a.each do |letter|
#   resp = RestClient.get("#{WURL}#{letter}"+"&namespace=0&limit=10&suggest=true", 'User-Agent' => 'Ruby')
#   arr = Crack::JSON.parse(resp)
#   #puts arr.join(', ')
#   wiki_file.write(arr)
#   wiki_file.write("\n")
#   sleep 0.5
# end

# wiki_file.close

#3 test Nokogiri
require 'rubygems'
require 'nokogiri'
require 'open-uri'

page = Nokogiri::HTML(open("http://mail.ru/"))   
puts page.class   # => Nokogiri::HTML::Document
