class Account
    attr_accessor :name, :currency, :balance, :nature

    def Account.create(name, currency, balance, nature)
        acc = Account.new
        acc.name = name
        acc.currency = currency
        acc.balance = balance
        acc.nature = nature
        return acc
        end

end