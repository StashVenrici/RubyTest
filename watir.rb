require 'rubygems'
require 'watir'
require 'open-uri'
require './account.rb'
require './transactions.rb'


def DoWithWatir()
  # open page
  browser = Watir::Browser.new :firefox
  browser.goto 'https://my.fibank.bg/oauth2-server/login?client_id=E_BANK'
  browser.window.maximize


  # Task 1 (sign into the bank interface)
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


  # Task 2 (print accounts info)
  browser.a(href: "/EBank/accounts/summ").click

  # create account array
  $acc_arr = []
  $acc_links = browser.links(href: /\/EBank\/accounts\/details/)
  # хз почему, но если не вызвать метод ".first.text" для коллекции ссылок, она остается пустой
  x = $acc_links.first.text #поэтому добавляем эту ненужную переменную и забываем о ней

  # print accounts info and saving to accounts array
  $i = 0
  $num = $acc_links.count
  while $i<$num do
    name = $acc_links[$i].text
    $acc_links[$i].click
    puts "-----------------------------------------------"
    puts "Account Nr #{$i+1}:"
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

  # Task 3 (Create an **Accounts class**) 
  # done - see file 'accounts.rb', created Account's class and "create_json_string" method for saving account's array to JSON string
  #end Task 3

  # Task 4 (Create a **Transactions class**)
  # done - see file 'transactions.rb', created Transactions class and "create_json_string" method
  #end Task 4

  # Task 5 (extend script to output the list of transactions for the last two months)
  # go to the transactions page:
  browser.element(xpath: '/html[1]/body[1]/div[1]/div[1]/div[1]/div[2]/div[3]/div[1]/div[2]/div[1]/ul[1]/li[3]/a[1]').click
  puts "\n"
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
      print '---No transactions found---'
      next
    end
    
    # handle transactions table
    table = browser.table(id: 'accountStatements')
    k = table.count  
    tr = []
    j = 3
    while j<=k-4 do
      puts 'Transaction Nr ' + (j-2).to_s
      row = table[j]
      tr[j-3] = Transactions.new()
      tr[j-3].date = row[0].text
      puts 'Date: ' + row[0].text
      if row[2].text.to_f == 0 then
        tr[j-3].amount = row[3].text.to_f
      else
        tr[j-3].amount = -(row[2].text.to_f)
      end
      puts 'Amount = ' + tr[j-3].amount.to_s
      tr[j-3].description = row[4].text
      puts 'Description: ' + row[4].text
      puts '==============================================='
      sleep(1)
      j +=1
    end
    
    puts 'Qty of transactions: ' + tr.length.to_s + "\n..."
    sleep(1)

    # bind transactions to account
    $acc_arr = BindTransactions(iban[0], tr, $acc_arr)
  end
  # Task 5 end

  puts "\n\n===================================="
  return Account.save_full_info($acc_arr)
end

# Task 6 (saving accounts with list of Transactions)
def BindTransactions(accname, tr_arr, acc_arr)
  acc_arr.each do |acc|
    if acc.name == accname
      acc.transactions = tr_arr
    end
  end
end
# Task 6 end


puts DoWithWatir()