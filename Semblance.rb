Shoes.app(title: "Semblance", width: 1200, height: 800) do
    background "#7A1D1F"
    title("Semblance",
    top: 60,
    align: "center",
    font: "Century Gothic",
    stroke: white)

	
	flow(){
        style(margin_left:'38%', margin_top:'75%')

        folder = nil
        
	    button("Select Folder") {
            folder = ask_open_folder()
        }

        button("Start Semblance") {
            Shoes.app :fullscreen => true do 
                @slide = nil
                stack(){                    
                    imagepath = generate_random_image_path(folder)
                    @slide = image(imagepath)

                    keypress do |k|
                        if (k.inspect == ":right") then
                            @slide.path = generate_random_image_path(folder)
                        end

                        if (k.inspect == ":escape") then
                            close()
                        end 
                    end
                }
            end
        }
    }
end

    
def generate_random_image_path(folder)
    images_list = Dir.entries(folder)
    accepted_exts = [".jpg", ".bmp", ".png", ".gif"]
    cur_image_path = images_list[rand(images_list.length)]
    while (accepted_exts.include? File.extname(cur_image_path)) then 
        return(folder + "\\" + cur_image_path)
    end 
end


class Slideshow
    @original_images_list = nil
    @shuffled_images_list = nil
    @current_images_list = nil 
    @images_length = 0
    @accepted_exts = [".jpg", ".bmp", ".png", ".gif"]
    @shuffle = false 
    @slide_length = 0
    @current_index = 0 
    

    def initialize(folder, shuffle, slide_length)
        @original_images_list = Dir.entries(folder)
        @images_length = @original_images_list.length 
        @current_images_list = @original_images_list
        if (shuffle) then 
            @shuffled_images_list = @original_images_list.shuffle
            @shuffle = shuffle
        end 
        @slide_length = slide_length
    end

    def next_image()
        image_index = @current_index
        end_of_list = (@current_index + 1) > @images_length
        img_path = @current_images_list[image_index]

        if (end_of_list)then
            @current_index = 0
        else
            @current_index = @current_index + 1
        end

        return img_path
    end

    # Note for bug: @images length in next and prev image should probably be images_length - 1
    # they are used for indexing, which means I will need another field in the class for length and max_index or something

    def prev_image()
        image_index = @current_index
        begin_of_list = (@current_index + 1) > @images_length
        img_path = @current_images_list[image_index]

        if (begin_of_list)then 
            @current_index = @images_length - 1
        else
            @current_index = @current_index - 1
        end
        
        return img_path
    end
    
    

    # when running, have the loop be true for shoes, inside class, return next image index as method in slideshow 
    
end 








def run_slideshow(folder, shuffle)
    images_list = Dir.entries(folder)
    accepted_exts = [".jpg", ".bmp", ".png", ".gif"]
    cur_image_path = images_list[rand(images_list.length)]
    if (shuffle) then 
        images_list = images_list.shuffle
    end

end 


# TODO Use an INI or something like it to store configuration settings 
# Flow of configurations:
    # Start up  --  Will include a new menu for configuring the INI 
    # Check for INI with config settings
    #     Not there: create a new INI 
    
    # INI Configuration Options

    