class TodoList

    attr_accessor :title, :items

    #attr_accessor :title
    def initialize(list_title)
    	@title = list_title
    	@items = Array.new # starts empty! No items yet!
    end

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

    def show
      puts self.title.center(20, '*')
      puts
      self.items.each do |item|
       puts "#{item.description.ljust(60, ' -')} Status: #{item.completed_status}"
      end
      puts
    end

    def completed?(index)
      @items[index].completed_status
    end

    def to_file(directory_and_file)
      output = File.new(directory_and_file, 'w+')
      output.puts self.title.center(20, '*')
      output.puts
      self.items.each do |item|
        output.puts "#{item.description.ljust(60, ' -')} Status: #{item.completed_status}"
      end
      output.puts
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
