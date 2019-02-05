require 'rubygems'
require 'open-uri'
require 'mechanize'

bank_url = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

agent = Mechanize.new

agent.get(bank_url)

form = agent.page.form_with(:id => 'form-signin')

form.field_with(:id => "username").value = "Pib123"
form.field_with(:id => "password").value = "Pib123"

    
puts "end"