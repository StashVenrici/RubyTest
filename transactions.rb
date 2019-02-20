require 'json'

class Transactions
  attr_accessor :date, :description, :amount
  def Transactions.create(date, description, amount)
    transactions = Transactions.new
    transactions.date = date
    transactions.description = description
    transactions.amount = amount
    return transactions
  end

   #create json string from array of transactions
   def Transactions.create_json_string(arr)
    #json begins
    json_str = '{"transactions":['
    #add every transaction to json_string
    for tr in arr do
      puts tr.date
      puts tr.description
      puts tr.amount
        json_str += {:date => tr.date, :description => tr.description, :amount => tr.amount}.to_json + ', '
    end
    #end json
    json_str = json_str[0..-3]
    json_str += ']}'
    return json_str
end
end
