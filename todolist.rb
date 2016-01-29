class TodoList

    attr_accessor :title, :items, :current_list, :hash_tag, :current_index

    #attr_accessor :title
    def initialize(list_title)
    	@hash_tag = Hash.new # starts empty Hash
    	@items = Array.new # starts empty! No items yet!
      @hash_tag[list_title] = []
      @current_list = list_title
      @current_index = 0
    end

    def add_list(list_title)
      @hash_tag[list_title] = []
      return "List with Title #{list_title} has been created"
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
      @current_index = list.hash_tag.key.length -1 # because the changed part will be at the end of the array
      return "Listname changed to #{new_title}"
    end
####################
##### NOT ADJUSTED TO MULTIPLE LISTS
####################

    def add_item(new_item)
        item = Item.new(new_item)
        @items.push(item)
    end

    def delete_item(index)
      @items.delete_at(index)
    end

    def item_completed(index)
      @items[index].completed_status = "true"
    end

    def show(output_method = 0)

      if output_method == 1
      liste = Tempfile.new('show_temp')
      liste.puts self.title.center(20, '*')
      liste.puts
      self.items.each do |item|
       liste.puts "#{item.description.ljust(60, ' -')} Status: #{item.completed_status}"
      end
      liste.puts
      liste.close
      return IO.read liste
    else
        puts self.title.center(20, '*')
        puts
        self.items.each do |item|
         puts "#{item.description.ljust(60, ' -')} Status: #{item.completed_status}"
        end
        puts
      end
    end

    def completed?(index)
      @items[index].completed_status
    end


    def to_file(directory_and_file = "report.txt")
      output = File.new("report.txt", 'w+')
      output.puts (self.show(1))
      output.close
      return "Output to file #{directory_and_file}"
    end

    def another_list(title)
      #@todolists.push(self)
    end

end

class Item
  attr_accessor :description, :completed_status

  def initialize(item_description)
    @description =  item_description
    @completed_status = false
  end

end
