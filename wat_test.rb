require "rubygems"
require "watir"
require 'open-uri'

browser = Watir::Browser.new :firefox
browser.goto "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"
#browser = Watir::Browser.start "https://my.fibank.bg/oauth2-server/login?client_id=E_BANK"

browser.window.maximize

#create account array
acc_arr=[]

#entering account
browser.text_field(name: 'username').set 'pib123'
browser.text_field(name: 'password').set 'pib123'
browser.button(id: 'submitBtn').click


#set english
lang_select_xpath = "/html[1]/body[1]/div[1]/div[1]/header[1]/nav[1]/ul[1]/li[1]/a[1]"
if browser.element(xpath: lang_select_xpath).text.upcase == "ENGLISH"
    browser.element(xpath: lang_select_xpath).click
end


#click on account with bgn currency
browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/table[1]/tbody[1]/tr[1]/td[1]/div[1]/div[1]/a[1]/span[1]").click

#save acc INFO

acc_arr.push(browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[4]/div[1]/div[1]/dl[1]/dd[3]").text)

acc_arr.push(browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[4]/div[1]/div[1]/dl[1]/dd[2]").text)

#acc_arr.push(browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/div[3]/h3[1]").text)
amount = browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[2]/div[1]/div[3]/h3[1]").text
amount_arr = amount.split(' ')
acc_arr.push(amount_arr[0].to_f)

acc_arr.push(browser.element(xpath: "/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[4]/div[1]/div[1]/dl[1]/dd[5]").text)

puts acc_arr.join(', ')

#task 2 - Account class
class Account
    attr_accessor :name, :currency, :balance, :nature
end

#Account class instance
account = Account.new
account.name = acc_arr[0]
account.currency = acc_arr[1]
account.balance = acc_arr[2]
account.nature = acc_arr[3]

#writing to .json
acc_file = open("account1.json", "w")
acc_file.write("\{\"accounts\"\:\n\[\n\{\n\"name\"\: \"" + account.name + "\",\n\"balance\"\: " + account.balance.to_s + ",\n\"currency\"\: \"" + account.currency + "\",\n\"nature\"\: \"" + account.nature + "\"\n\}\n\]\n\}")