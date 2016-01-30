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

list.item_complete(1)

# Print the list

list.show

# Update the title of the list

list.change_name_to("Not managed to buy")

# Print the list

list.show

# add a new list

list.add_list("at home")

# change the current list to "At Home"

list.change_list_to("at home")

# show current list

list.current_list

# change Name of the current list

list.change_name_to("At Home")

# delete "Shopping List"

list.delete_list("Shopping List")

# add a new item to the current list

list.add_item("wash dishes")
list.add_item("clean up room")

# show list

list.show

# save list to file -> "report.txt" will be used if there is no value passed

list.to_file

# change name of the list (so that we can load the other list --> no duplicate naming allowed)

list.change_name_to("At Home second version")

# load the saved list --> The loaded list will be the new current list

list.load_from_file("report.txt")

# show list

list.show
