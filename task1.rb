require 'rubygems'
require 'open-uri'
require 'mechanize'

bank_url = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

agent = Mechanize.new

page = agent.get(bank_url)

form = page.form_with(:id => 'form-signin')

form.field_with(:id => "username").value = "Pib123"
form.field_with(:id => "password").value = "Pib123"

login = agent.submit(form)

    
puts "end"