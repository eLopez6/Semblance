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
                    images = Dir.entries(folder)
                    imagepath = (folder + "\\" + images[rand(images.length)])
                    @slide = image(imagepath)

                    keypress do |k|
                        if (k.inspect == ":right") then
                            @slide.path = generateImagePath(folder, images)
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

    
        
            
        
            
                
                        


# def generateImagePath(folder, imagesList)
#     return  (folder + "\\" + imagesList[rand(imagesList.length)])
# end


#TODO 
# keypress(|key| ...), will allow me to use hotkeys like waiting for an arrow to load the next picture 
#REMEMBER : image(PATH), returns Shoes::Image, 
# or apparently just image "PATH" 


# folderpath = gets.chomp()

# images = Dir.entries(folderpath)
# imagepath = images[rand(images.length)]
# puts folderpath + imagepath
            