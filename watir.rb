require 'rubygems'
require 'watir'
require 'open-uri'

browser = Watir::Browser.new :firefox
browser.goto 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'

browser.window.maximize

# create account array
acc_arr = []

# entering bank account
browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click

# switch to the English version of the site
lang_select_xpath = '/html[1]/body[1]/div[1]/div[1]/header[1]/nav[1]/ul[1]/li[1]/a[1]'
if browser.element(xpath: lang_select_xpath).text.casecmp('ENGLISH').zero?
  browser.element(xpath: lang_select_xpath).click
end
sleep(1)

acc_page = browser.element(id: "step3").click
sleep(1)

$acc_links = Array.new
$acc_links = browser.as(class: "s1")

$i = 0
$num = $acc_links.count
while $i<$num do
  $acc_links[$i].click
  #TODO - capture acc info
  puts browser.title
  sleep(1)
  browser.back
  sleep(1)
  $i += 1
end

browser.close