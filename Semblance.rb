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

# TODO Refactor this into two methods 
# This method should be called by another method which handles the time calculation
def time_slideshow(images)
    



    sleep(3)
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

    