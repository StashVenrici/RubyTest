require 'rubygems'
require 'watir'
require 'open-uri'
require './account.rb'
require './transactions.rb'



browser = Watir::Browser.new :firefox
browser.goto 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'
# browser = Watir::Browser.start "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

browser.window.maximize

# create account array
acc_arr = []

# entering account
browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click



# set english
lang_select_xpath = '/html[1]/body[1]/div[1]/div[1]/header[1]/nav[1]/ul[1]/li[1]/a[1]'
if browser.element(xpath: lang_select_xpath).text.casecmp('ENGLISH').zero?
  browser.element(xpath: lang_select_xpath).click
end

# click on account with bgn currency
browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/table[1]/tbody[1]/tr[1]/td[1]/div[1]/div[1]/a[1]/span[1]').click

# save acc INFO
acc_arr.push(browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[4]/div[1]/div[1]/dl[1]/dd[3]').text)

acc_arr.push(browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[4]/div[1]/div[1]/dl[1]/dd[2]').text)

# acc_arr.push(browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/div[3]/h3[1]").text)
amount = browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/div[3]/h3[1]').text
amount_arr = amount.split(' ')

acc_arr.push(amount_arr[0].to_f)

acc_arr.push(browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[4]/div[1]/div[1]/dl[1]/dd[5]').text)

puts acc_arr.join(', ')

# Account class instance
account = Account.create(acc_arr[0], acc_arr[1], acc_arr[2], acc_arr[3])

# writing acc info to .json
acc_file = open('accounts.json', 'w')
acc_file.write("\{\"accounts\"\:\n\[\n\{\n\"name\"\: \"" + account.name + "\",\n\"balance\"\: " + account.balance.to_s + ",\n\"currency\"\: \"" + account.currency + "\",\n\"nature\"\: \"" + account.nature + "\"\n\}\n\]\n\}")
acc_file.close



# move to bgn transactions
browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/ul[1]/li[3]/a[1]').click

# date interval
date_from = "01/10/2018"
date_to = "01/01/2019"

# enter dates to fields to get transactions info
browser.text_field(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/form[1]/div[2]/div[1]/div[1]/div[1]/div[1]/input[1]').set '01/10/2018'
browser.text_field(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/form[1]/div[2]/div[2]/div[1]/div[1]/div[1]/input[1]').set '01/01/2019'
browser.element(:id => 'button').click

#reading transactions
tr_xpath = '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/form[1]/div[4]/div[1]/div[2]/div[1]/div[1]/div[1]/table[1]/tbody[1]/tr['
tr_xpath_date = ']/td[1]/div[1]/span[1]'
tr_xpath_am1 = ']/td[3]/div[1]/span[1]'
tr_xpath_am2 = ']/td[4]/div[1]/span[1]'
tr_xpath_desc1 = ']/td[5]/div[1]/div[1]/p[1]'
tr_xpath_desc2 = ']/td[5]/div[1]/div[1]/p[2]'
tr_xpath_desc3 = ']/td[5]/div[1]/div[1]/a[1]'
tr_xpath_desc4 = ']/td[5]/div[1]/div[1]/p[1]'

i = 1
trans_arr = []
transaction = Transactions.new
_xpath = tr_xpath + i.to_s + tr_xpath_date

while browser.element(xpath: _xpath).exist? do
  #date
  _xpath = tr_xpath + i.to_s + tr_xpath_date
  transaction.date = browser.element(xpath: _xpath).text
  
  #amount and description    
   _xpath = tr_xpath + i.to_s + tr_xpath_am1
   _xpath1 = tr_xpath + i.to_s + tr_xpath_am2
   if browser.element(xpath: _xpath1).text.to_f == 0 
     transaction.amount = (browser.element(xpath: _xpath).text.to_f)*(-1.0)
     _xpath = tr_xpath + i.to_s + tr_xpath_desc1
     _xpath1 = tr_xpath + i.to_s + tr_xpath_desc2
     transaction.description = browser.element(xpath: _xpath).text + " " + browser.element(xpath: _xpath1).text
   else
    #
    transaction.amount = browser.element(xpath: _xpath1).text.to_f
    _xpath = tr_xpath + i.to_s + tr_xpath_desc3
    _xpath1 = tr_xpath + i.to_s + tr_xpath_desc4
    transaction.description = browser.element(xpath: _xpath).text + " " + browser.element(xpath: _xpath1).text
   end

  trans_arr.push(transaction)
  i = i + 1
  _xpath = tr_xpath + i.to_s + tr_xpath_date
end

# save transactions to file
#trs_file = open('transactions.json', 'w')
#TODO: write to file
#trs_file.close