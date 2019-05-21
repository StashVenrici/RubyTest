require 'json'

class Transactions
  attr_accessor :date, :description, :amount
  
  def initialize(date = "", description = "", amount = 0)
    @date = date
    @description = description
    @amount = amount
  end

  #create json string from array of transactions
  def Transactions.create_json_string(arr)
    if arr.empty?  then 
      return '{"transactions":[]}' 
    end
    #json begins
    json_str = '{"transactions":['
    #add every transaction to json_string
    for tr in arr do
        json_str += {:date => tr.date, :description => tr.description, :amount => tr.amount}.to_json + ', '
    end
    #end json
    json_str = json_str[0..-3]
    json_str += ']}'
    return json_str
  end

  # print out transaction info
  def GetTransactionInfo()
    return "Date:\t" + self.date + "\nAmount:\t" + self.amount.to_s + "\nDescription:\t" + self.description
  end
end
