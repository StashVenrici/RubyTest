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

#так видит ссылки
# puts browser.as(class: "s1")[0].href
# puts browser.as(class: "s1")[1].href
sleep(1)
# puts browser.as(class: "s1").count

$acc_links = Array.new
$acc_links = browser.as(class: "s1")

$i = 0
$num = $acc_links.count
# puts 'num = ' + $num.to_s
while $i<$num do
  puts 'i = ' + $i.to_s
  puts $array1[$i].href
  $i += 1
end

# browser.quit