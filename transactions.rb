class Transactions
  attr_accessor :date, :description, :amount
  def Transactions.create(date, description, amount)
    transactions = Transactions.new
    transactions.date = date
    transactions.description = description
    transactions.amount = amount
  end
end
