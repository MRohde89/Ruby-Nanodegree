require_relative 'todolist.rb'

# Creates a new todo list

list = TodoList.new("Shopping List")

# Add four new items

list.add_item("Something for lunch")
list.add_item("Buy Bananas :-)")
list.add_item("New Shoes")
list.add_item("Power Ranger special collection figure")

# Print the list

list.show

# Delete the first item

list.delete_item(0)

# Print the list

list.show

# Delete the second item

list.delete_item(1)

# Print the list

list.show

# Update the completion status of the first item to complete

list.item_completed(1)

# Print the list

list.show

# Update the title of the list

list.title = "Not managed to buy"

# Print the list

list.show
