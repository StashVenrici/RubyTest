require 'rubygems'
require 'open-uri'
require 'mechanize'

bank_url = "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

agent = Mechanize.new
agent.user_agent_alias = 'Windows Chrome'

page = agent.get(bank_url)

form = page.form_with :id => "form-signin"

form.field_with(:name => "username").value = "Pib123"
form.field_with(:name => "password").value = "Pib123"

log_on = agent.submit
puts log_on.title
    
puts "end"