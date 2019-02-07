require "watir"

#browser = Watir::Browser.new :chrome
#browser.goto "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

browser = Watir::Browser.start "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK", :chrome
browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click
puts browser.element(id: 'user--identificator').text