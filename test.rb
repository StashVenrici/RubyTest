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
# require 'rubygems'
# require 'nokogiri'
# require 'open-uri'
# require 'selenium-webdriver'

# # page = Nokogiri::HTML(open("http://mail.ru/"))   
# # puts page.class   # => Nokogiri::HTML::Document

# options = Selenium::WebDriver::Chrome::Options.new(args: ['headless'])

# driver = Selenium::WebDriver.for(:chrome, options: options)

# driver.get('https://my.fibank.bg/oauth2-server/login?client_id=E_BANK')

# puts driver.html

# driver.quit


# test browsing page
require 'watir'

browser = Watir::Browser.new :firefox
browser.goto 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'
browser.window.maximize
sleep(5)

browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click
sleep(5)

lang_select_xpath = '/html[1]/body[1]/div[1]/div[1]/header[1]/nav[1]/ul[1]/li[1]/a[1]'
if browser.element(xpath: lang_select_xpath).text.casecmp('ENGLISH').zero?
  browser.element(xpath: lang_select_xpath).click
end
sleep(5)

browser.a(href: "/EBank/accounts/summ").click
sleep(5)


puts "end"