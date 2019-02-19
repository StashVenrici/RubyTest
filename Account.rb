require 'json'
require './transactions.rb'

class Account
    attr_accessor :name, :currency, :balance, :nature, :transactions

    def Account.create(name, currency, balance, nature, transactions=[])
        acc = Account.new
        acc.name = name
        acc.currency = currency
        acc.balance = balance
        acc.nature = nature
        return acc
    end

    #create json string from array of accounts
    def Account.create_json_string(arr)
        #json begins
        json_str = '{"accounts":['
        #add every acc to json_string
        for acc in arr do
            json_str += {:name => acc.name, :currency => acc.currency, :balance => acc.balance, :nature => acc.nature}.to_json + ', '
        end
        #end json
        json_str = json_str[0..-3]
        json_str += ']}'
        return json_str
    end

    #create json string from array of accounts with transactions
    def Account.save_full_info(accs)
        #TODO:
        
    end

end