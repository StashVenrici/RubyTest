# Task 7 (use nokogiri objects)
require 'rubygems'
require 'watir'
require 'nokogiri'
require 'open-uri'
require './account.rb'
require './transactions.rb'

def BindTransactions(accname, tr_arr, acc_arr)
  acc_arr.each do |acc|
    if acc.name == accname
      acc.transactions = tr_arr
    end
  end
end

# Task 7 (Use Nokogiri)

def DoWithNokogiri()
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
  # поэтому добавляем эту ненужную переменную и забываем о ней:
  x = acc_links.first.text

  # print accounts info and saving to accounts array
  i = 0
  $num = acc_links.count
  while i<$num do
    name = acc_links[i].text
    acc_links[i].click

    # конвертировать страницу в объект Nokogiri
    nokpage = Nokogiri::HTML(browser.html)

    puts "-----------------------------------------------"
    puts "Account Nr #{i+1}:"
    puts 'Name: ' + name

    balance_str = nokpage.css("h3[@class='blue-txt ng-binding ng-scope']").text
    balance_arr = balance_str.split(' ')
    balance = balance_arr[0].to_f
    currency = balance_arr[1]

    puts 'Currency: ' + currency
    puts 'Balance: ' + balance.to_s

    # nature = browser.dt(text: /Category:/).following_sibling.text
    nature = nokpage.css("dd[@class='ng-scope']").text
    puts 'Nature: ' + nature
    $acc_arr[i] = Account.new(name, currency, balance, nature)
    sleep(1)
    browser.back
    sleep(1)
    i += 1
  end
  
  # go to the transactions page:
  browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/ul[1]/li[3]/a[1]').click
  puts "\n++++++++++++++++++++++++++++++++++\n"
  sleep(1)
  browser.button(class: ["btn", "dropdown-toggle", "btn-default"]).click

  # saving accounts links
  list = browser.ul(class: ["dropdown-menu", "inner"])
  browser.button(class: ["btn", "dropdown-toggle", "btn-default"]).click

  # open each link to see transactions
  list.each do |elem|
    browser.button(class: ["btn", "dropdown-toggle", "btn-default"]).click

    # save iban to bind transactions to concret accout later
    iban = elem.a.text
    iban = iban.split(' ')
    # puts "Transactions: " + elem.a.text
    puts "Transactions: " + iban[0]
    elem.a.click

    # find transactions for two month
    browser.text_field(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/form[1]/div[2]/div[1]/div[1]/div[1]/div[1]/input[1]').set '01/10/2018'
    browser.text_field(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/form[1]/div[2]/div[2]/div[1]/div[1]/div[1]/input[1]').set '01/01/2019'
    browser.element(:id => 'button').click
    sleep(1)

    # if no transactions, go to next acc
    if !browser.table(id: 'accountStatements').exist?
      print "---No transactions found---\n\n"
      next
    end

    # handle transactions table
    # table = browser.table(id: 'accountStatements')
    tr = []
    trcounter = 1
    noktable = Nokogiri::HTML(browser.html)
    table = noktable.css("table#accountStatements")
    tbrows = table.css('tr')
    tbrows[3..-4].each do |row|
      puts 'Transaction nr ' + (trcounter).to_s + ':'
      trs = Transactions.new()
      trs.date = row.css('td')[0].text
      if (row.css('td')[2].text.to_f == 0) then
        trs.amount = row.css('td')[3].text.to_f
      else
        trs.amount = -(row.css('td')[2].text.to_f)
      end
      trs.description = row.css('td')[4].text
      # add transaction to array
      tr.push(trs)
      puts trs.GetTransactionInfo()
      trcounter += 1
    end

    puts "\nQty of transactions: " + tr.length.to_s + "\n..."
    sleep(1)
    # bind transactions to account:
    $acc_arr = BindTransactions(iban[0], tr, $acc_arr)
    puts "----------------------------------------------------------\n"
  end #end accounts links actions

  return Account.save_full_info($acc_arr)
end #end DoWithNokogiri method

puts DoWithNokogiri()