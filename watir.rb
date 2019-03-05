require 'rubygems'
require 'watir'
require 'open-uri'
require './account.rb'
require './transactions.rb'

browser = Watir::Browser.new :firefox
browser.goto 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'
browser.window.maximize


# Task 1 
# entering bank account:
browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click
#end Task 1

# switch to the English version of the site
lang_select_xpath = '/html[1]/body[1]/div[1]/div[1]/header[1]/nav[1]/ul[1]/li[1]/a[1]'
if browser.element(xpath: lang_select_xpath).text.casecmp('ENGLISH').zero?
  browser.element(xpath: lang_select_xpath).click
end
sleep(1)


# Task 2
# print accounts info:
acc_page = browser.element(id: "step3").click
sleep(1)

# create account array
$acc_arr = []

$acc_links = Array.new
$acc_links = browser.as(class: "s1")

$i = 0
$num = $acc_links.count
while $i<$num do
  $acc_links[$i].click
  puts "Account Nr #{$i+1}:"
  name = browser.dt(text: /Account owner:/).following_sibling.text
  puts 'Name: ' + name
  currency = browser.dt(text: /Currency:/).following_sibling.text
  puts 'Currency: ' + currency
  balance_str = browser.span(text: /Available balance:/).following_sibling.text
  balance_arr = balance_str.split(' ')
  balance = balance_arr[0].to_f
  puts 'Balance: ' + balance.to_s
  nature = browser.dt(text: /Category:/).following_sibling.text
  puts 'Nature: ' + nature
  $acc_arr[$i] = Account.new(name, currency, balance, nature)
  
  sleep(1)
  browser.back
  sleep(1)
  $i += 1
end
#end Task 2

browser.close