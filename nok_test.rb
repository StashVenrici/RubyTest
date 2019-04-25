require 'rubygems'
require 'nokogiri'
require 'mechanize'
require 'open-uri'
require 'rest-client'

agent = Mechanize.new
agent.user_agent_alias = 'Windows Firefox'
# page = agent.get 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'
hdata = open('https://my.fibank.bg/oauth2-server/login?client_id=E_BANK').read

page = Nokogiri::HTML(RestClient.get("https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"))

# puts hdata
# puts page.inspect
puts page.to_s

# login_form.field_with(:name => "username").value = "Pib123"
# login_form.field_with(:name => "password").value = "Pib123"