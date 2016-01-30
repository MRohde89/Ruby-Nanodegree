require "Tempfile"

class TodoList

    attr_accessor :title, :items, :current_list, :hash_tag

    #attr_accessor :title
    def initialize(list_title)
    	@hash_tag = Hash.new # starts empty Hash
    	@items = Array.new # starts empty! No items yet!
      @hash_tag[list_title] = []
      @current_list = list_title
    end

    def add_list(list_title)
      @hash_tag[list_title] = []
      return "List with title #{list_title} has been created"
    end

    def delete_list(list_title)
      if @current_list == list_title
        return "Can not delete current list. choose another list do delete #{list_title}"
    elsif
      self.hash_tag.keys.include? list_title
      self.hash_tag.delete(list_title)
      return "List #{list_title} has been deleted"
    else
      return "No such List #{list_title}"
    end
    end

    def load_from_file(filename)
      file = File.readlines(filename)
      file.each_with_index do |line, index|
        if index == 0
          hash_tag = line.gsub("*", "").gsub("\n", "")
          if self.hash_tag.keys.include? hash_tag
            return "List can not be loaded because there is a list with name '#{hash_tag}' already"
          else
            add_list(hash_tag)
            @current_list = hash_tag
            puts "Current list is now #{hash_tag}"
          end
        elsif line == "\n"
          next
        else
          item = line.split(";")
          description = item[0].gsub(" -","").gsub("Task: ","")
          status = item[1].gsub(" Finished: ", "").gsub("\n", "")
          self.add_item(description)
          status == "true" ? self.item_complete(index-2) : self.item_uncomplete(index-2)
          # index-2 because line 0 is always the header followed by an "\n" in line 1; afterwards line 2 will be item 0
      end
    end

    end



    def current_list
      return @current_list
    end

    def change_to_list(list)
      if
      self.hash_tag.keys.include? list
      @current_list = list
      return "List has been changed to #{current_list}"
    else
      return "No such list"
    end
    end

    def show_lists
      return self.hash_tag.keys
    end

    def change_name_to(new_title)
      replacement = { @current_list => new_title }
      # Renaming Solution for hash keys from Stackoverflow: http://stackoverflow.com/questions/4137824/how-to-elegantly-rename-all-keys-in-a-hash-in-ruby
      self.hash_tag.keys.each { |k| self.hash_tag[replacement[k]] = self.hash_tag.delete(k) if replacement[k]}
      @current_list = new_title
      #@current_index = list.hash_tag.key.length -1 # because the changed part will be at the end of the array
      return "Listname changed to #{new_title}"
    end

    def add_item(new_item)
        item = Item.new(new_item)
        self.hash_tag[@current_list].push(item)
    end

    def delete_item(index)
      self.hash_tag[@current_list].delete_at(index)
    end

    def item_complete(index)
      self.hash_tag[@current_list][index].completed_status = "true"
    end

    def item_uncomplete(index)
      self.hash_tag[@current_list][index].completed_status = "false"
    end

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
      return IO.read liste
    else
        puts @current_list.center(20, '*')
        puts
        self.hash_tag[@current_list].each_with_index do |item, index|
         puts "#{index}. Task: #{item.description.ljust(60, ' -')} Finished: #{item.completed_status}"
        end
        puts
      end
    end


    def completed?(index)
      self.hash_tag[@current_list][index].completed_status
    end


    def to_file(directory_and_file = "report.txt")
      output = File.new("report.txt", 'w+')
      output.puts (self.show(1))
      output.close
      return "Output to file #{directory_and_file}"
    end

end

class Item
  attr_accessor :description, :completed_status

  def initialize(item_description)
    @description =  item_description
    @completed_status = false
  end

end
