require 'json'
require './transactions.rb'

class Account
    attr_accessor :name, :currency, :balance, :nature, :transactions

    def initialize(name, currency, balance, nature, transactions = [])
        @name = name
        @currency = currency
        @balance = balance
        @nature = nature
        @transactions = transactions
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
         #json begins
         json_str = '{"accounts":['

         for acc in accs do
            json_str += {:name => acc.name, :currency => acc.currency, :balance => acc.balance, :nature => acc.nature}.to_json
            json_str = json_str[0..-2]
            #TODO: cover case no transactions!
            if acc.transactions == []
                json_str += ', "transactions": []}, '
            else 
                json_str += ', "transactions": ['
                for tr in acc.transactions do
                    json_str +={:date => tr.date, :description => tr.description, :amount => tr.amount}.to_json + ', '
                end
                json_str = json_str[0..-3]
                json_str += ']}, '
            end
        end
        json_str = json_str[0..-3]
        json_str += ']}'
        return json_str
    end

end