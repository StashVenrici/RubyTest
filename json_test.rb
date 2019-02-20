require 'json'
require './account.rb'
require './transactions.rb'


acc = Account.create("Ivan", "USD", 12.75, "current")
#str = {:name => acc.name, :currency => acc.currency, :balance => acc.balance, :nature => acc.nature}
#puts str.to_json

#test array of accs to json
acc2 = Account.create("Tolyan", "EUR", 1500, "current")
#arr = []
# arr.push(acc)
# arr.push(acc2)
#puts Account.create_json_string(arr)

#test array of transactions to json
# tr1 = Transactions.create('12/02/18', 'description 1', 12.89)
# tr2 = Transactions.create('02/03/18', 'description 2', 50.16)
arr_tr = []
# arr_tr.push(tr1)
# arr_tr.push(tr2)
arr_tr[0] = Transactions.create('12/02/18', 'description 1', 12.89)
arr_tr[1] = Transactions.create('02/03/18', 'description 2', 50.16)

puts Transactions.create_json_string(arr_tr)

# acc.transactions = arr_tr
# acc2.transactions = arr_tr
# arr = [acc, acc2]

# puts Account.save_full_info(arr)