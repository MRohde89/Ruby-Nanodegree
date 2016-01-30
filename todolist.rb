require "Tempfile" #used for the to_file method

## This class creates an hash for every list.
## Every hash includes an array for all items (class Item) in this hash/list
class TodoList

    attr_accessor :items, :hash_tag, :current_list

    def initialize(list_title)
    	@hash_tag = Hash.new # starts empty Hash
    	@items = Array.new # starts empty! No items yet!
      @hash_tag[list_title] = []
      @current_list = list_title
    end

    # add a new list to your lists
    def add_list(list_title)
      @hash_tag[list_title] = []
      return "List with title #{list_title} has been created"
    end

    # delete a list from your lists
    def delete_list(list_title)
      if @current_list == list_title # it is not allowed to delete the current list!
        return "Can not delete current list. choose another list do delete #{list_title}"
    elsif
      self.hash_tag.keys.include? list_title # if given list is in the list hash
      self.hash_tag.delete(list_title)
      return "List #{list_title} has been deleted"
    else
      return "No such List #{list_title}"
    end
    end

    # loads from a given file.
    def load_from_file(filename)
      file = File.readlines(filename)
      file.each_with_index do |line, index|
        if index == 0 # index 0 is always the header (see .show method with output_type == 1)
          hash_tag = line.gsub("*", "").gsub("\n", "") # some substring to get the name of the list
          if self.hash_tag.keys.include? hash_tag # if list name is already in the lists, then it won't be loaded
            return "List can not be loaded because there is a list with name '#{hash_tag}' already"
          else
            add_list(hash_tag) # add a new list
            @current_list = hash_tag # change current list to the loaded list (it was simply easier, because now all other list-methods can be used as well (they always use the current_list variable))
            puts "Current list is now #{hash_tag}"
          end
        elsif line == "\n" # if just empty line then skip
          next
        else
          # every line has the description as well as the status in it. some substrings used
          item = line.split(";")
          description = item[0].gsub(" -","").gsub("Task: ","")
          status = item[1].gsub(" Finished: ", "").gsub("\n", "")
          self.add_item(description)
          status == "true" ? self.item_complete(index-2) : self.item_uncomplete(index-2)
          # index-2 because line 0 is always the header followed by an "\n" in line 1; afterwards line 2 will be item 0
      end
    end

    end


    # show current list
    def current_list
      return @current_list
    end

    # change current list
    def change_list_to(list)
      if
      self.hash_tag.keys.include? list
      @current_list = list
      return "List has been changed to #{current_list}"
    else
      return "No such list"
    end
    end

    # show all lists
    def show_lists
      return self.hash_tag.keys
    end

    # change the name of the list; This is not as easy as it sounds like, because a hash key is frozen and can not be changed after it is defined
    def change_name_to(new_title)
      replacement = { @current_list => new_title }
      # Renaming Solution for hash keys from Stackoverflow: http://stackoverflow.com/questions/4137824/how-to-elegantly-rename-all-keys-in-a-hash-in-ruby
      self.hash_tag.keys.each { |k| self.hash_tag[replacement[k]] = self.hash_tag.delete(k) if replacement[k]}
      @current_list = new_title
      #@current_index = list.hash_tag.key.length -1 # because the changed part will be at the end of the array
      return "Listname changed to #{new_title}"
    end

    # add a new item
    def add_item(new_item)
        item = Item.new(new_item)
        self.hash_tag[@current_list].push(item)
    end

    # delete an item
    def delete_item(index)
      self.hash_tag[@current_list].delete_at(index)
    end

    # mark an item as completed
    def item_complete(index)
      self.hash_tag[@current_list][index].completed_status = "true"
    end

    # mark an item as uncompleted
    def item_uncomplete(index)
      self.hash_tag[@current_list][index].completed_status = "false"
    end

    # show the list
    # there are different output methods needed in order to save the list to a file (.to_file)
    # in output_method = 0, the list will be just puts --> no return
    # because the to_file method takes the output/return from the show method it has to return the output (solved with tempfile)
    def show(output_method = 0)

      if output_method == 1
      liste = Tempfile.new('show_temp')
      liste.puts @current_list.center(20, '*')
      liste.puts
      self.hash_tag[@current_list].each do |item|
       liste.puts "Task: #{item.description.ljust(60, ' -')}; Finished: #{item.completed_status}"
      end
      liste.puts
      liste.close
      return IO.read liste # return is used for the to_file method
    else
        puts
        puts @current_list.center(20, '*')
        puts
        self.hash_tag[@current_list].each_with_index do |item, index|
         puts "#{index}. Task: #{item.description.ljust(60, ' -')} Finished: #{item.completed_status}"
        end
        puts
      end
    end

    # shows if a task is completed or not
    def completed?(index)
      self.hash_tag[@current_list][index].completed_status == true ? true : false
    end

    # used to generate a report to a text file
    def to_file(directory_and_file = "report.txt")
      output = File.new(directory_and_file, 'w+')
      output.puts (self.show(1)) # output_method 1--> see .show
      output.close
      return "Output to file #{directory_and_file}"
    end

end

# Class Item is used to create a new item into a list
# to create an item the item_description needs to be defined
class Item
  attr_accessor :description, :completed_status

  def initialize(item_description)
    @description =  item_description
    @completed_status = false
  end

end
