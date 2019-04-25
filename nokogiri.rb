# Task 7 (use nokogiri objects)
require 'rubygems'
require 'watir'
require 'nokogiri'
require 'open-uri'
require './account.rb'
require './transactions.rb'

# Task 7 (Use Nokogiri)

# def DoWithNokogiri()
  # open page
  browser = Watir::Browser.new :firefox
  browser.goto 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'
  browser.window.maximize

  # entering bank account:
  browser.text_field(name: 'username').set 'pib123'
  browser.text_field(name: 'password').set 'pib123'
  browser.button(id: 'submitBtn').click

  # switch to the English version of the site
  lang_select_xpath = '/html[1]/body[1]/div[1]/div[1]/header[1]/nav[1]/ul[1]/li[1]/a[1]'
  if browser.element(xpath: lang_select_xpath).text.casecmp('ENGLISH').zero?
    browser.element(xpath: lang_select_xpath).click
  end
  sleep(1)

  # go to the accounts summary
  browser.a(href: "/EBank/accounts/summ").click

  # create account array
  $acc_arr = []

  acc_links = browser.links(href: /\/EBank\/accounts\/details/)
  # хз почему, но если не вызвать метод ".first.text" для коллекции ссылок, она остается пустой
  # поэтому добавляем эту ненужную переменную и забываем о ней
  x = acc_links.first.text

  # print accounts info and saving to accounts array
  i = 0
  $num = acc_links.count
  while i<$num do
    # TODO: здесь переделать под Nokogiri

    name = acc_links[i].text
    acc_links[i].click

    # конвертировать страницу в объект Nokogiri
    nokpage = Nokogiri::HTML(browser.html)

    puts "-----------------------------------------------"
    puts "Account Nr #{i+1}:"
    puts 'Name: ' + name

    # извлекаем currency
    # currency = browser.dt(text: /Currency:/).following_sibling.text
    # currency = nokpage.css("dd[ng-bind='model.acc.ccy']")

    
    puts nokpage.css("dd[ng-bind='model.acc.ccy']").text #не работает
    puts nokpage.css("dt[translate='PAGES.ACCOUNT_DETAIL.INFO.CCY']").text #здесь работает
    File.open('page.html','w'){ |file| file.write browser.html }

    # puts 'Currency: ' + currency
    # balance_str = browser.span(text: /Available balance:/).following_sibling.text
    # balance_arr = balance_str.split(' ')
    # balance = balance_arr[0].to_f
    # puts 'Balance: ' + balance.to_s
    # nature = browser.dt(text: /Category:/).following_sibling.text
    # puts 'Nature: ' + nature
    # $acc_arr[$i] = Account.new(name, currency, balance, nature)
    
    sleep(1)
    browser.back
    sleep(1)
    i += 1
  end
  
  
  # convert page to nokogiri object
  # page = Nokogiri::HTML(browser.html)
  # puts page.class
# end

# DoWithNokogiri()
