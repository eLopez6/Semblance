Shoes.setup do
    gem 'inifile'
end

require 'inifile'

# Setup of INI for accessing default values
if (File.file?('./slides.ini')) then
    ini_file = IniFile.load('./slides.ini')
else
    # Create new IniFile
    ini_file = IniFile.new
    ini_file["Default"] = {
        "Length" => '3',
        "Shuffle" => '0'
    }
    ini_file.filename = "./slides.ini"
    ini_file.write()
end

# Get default values from a config file
data = ini_file["DEFAULT"]

configured_slide_length = data["Length"].to_i
if data["Shuffle"] == '0' then
    configured_shuffle = false
else
    configured_shuffle = true
end

Shoes.app(title: "Semblance", width: 1200, height: 800) do
    background "#7A1D1F"
    title("Semblance",
    top: 60,
    align: "center",
    font: "Century Gothic",
    stroke: white)

    stack() {
        flow(margin_left:'38%', margin_top:'40%') {
            splash = image("./RUby23.png")
        }
        flow(margin_left:'38%', margin_top:'15%'){
            selected_folder = ''

            button("Select Folder") {
                selected_folder = ask_open_folder
            }

            button("Start Semblance") {
                Shoes.app(fullscreen: true) do
                    background "#000000"

                    @original_images_list = nil
                    @shuffled_images_list = nil
                    @current_images_list = nil
                    @images_length = 0
                    @shuffle = false
                    @slide_length = 3
                    @current_index = 0
                    @folder = ''

                    if Gem.win_platform? then
                        @screen_width = `powershell Get-WmiObject -Class Win32_DesktopMonitor`.scan(/ScreenWidth \s+ : (\d+)/).flatten
                        @screen_width = @screen_width.first.to_i
                        @screen_height = `powershell Get-WmiObject -Class Win32_DesktopMonitor`.scan(/ScreenHeight \s+ : (\d+)/).flatten
                        @screen_height = @screen_height.first.to_i
                    else
                        @screen_width, @screen_height = `xrandr`.scan(/current (\d+) x (\d+)/).flatten    # Not sure what is actually happening here
                        @screen_width = @screen_width.to_i
                        @screen_height = @screen_height.to_i
                    end

                    stack() {
                        slideshow_start(selected_folder, configured_shuffle,
                        configured_slide_length)
                        x1 = 0
                        y1 = 0

                        slide = image
                        new_slide(slide, true)

                        every(@slide_length) do
                            new_slide(slide, true)
                        end

                        keypress do |k|
                            if (k.inspect == ":right") then
                                new_slide(slide, true)
                            end

                            if (k.inspect == ":left") then
                                new_slide(slide, false)
                            end

                            if (k.inspect == ":escape") then
                                close()
                            end
                        end
                    }
                end
            }
        }
    }


end

# Methods

def new_slide(slide, forward)
    if (forward) then
        slide.path = next_image
    else
        slide.path = prev_image
    end
    x1, y1 = scale_image(slide.full_width, slide.full_height, @screen_width, @screen_height)
    w, h = center_image(x1, y1, @screen_width, @screen_height)
    slide.style(:width => x1, :height => y1, :displace_left => w, :displace_top => h)
end

def slideshow_start(folder, shuffle_set, slide_length)
    @original_images_list = Dir.entries(folder).select {|f| !File.directory? f}
    accepted_exts = [".jpg", ".bmp", ".png", ".gif"]
    # Remove from the slideshow files that are not images (ie, webms)
    @original_images_list = @original_images_list.select {|elem|
        accepted_exts.include? File.extname(elem)
    }
    @images_length = @original_images_list.length    # makes code cleaner
    if (shuffle_set) then
        @shuffle = shuffle_set
        @shuffled_images_list = @original_images_list.shuffle
        @current_images_list = @shuffled_images_list
    else
        @current_images_list = @original_images_list
    end
    @folder = folder
    @slide_length = slide_length
end

def next_image
    end_of_list = (@current_index + 1) > (@images_length - 1)
    if (end_of_list) then
        @current_index = 0
    else
        @current_index += 1
    end

    image_index = @current_index
    img_path = @current_images_list[image_index]
    return @folder + '/' + img_path
end

def prev_image
    begin_of_list = (@current_index - 1) < 0

    if (begin_of_list) then
        @current_index = @images_length - 1
    else
        @current_index = @current_index - 1
    end

    image_index = @current_index
    img_path = @current_images_list[image_index]
    return @folder + '/' + img_path
end

def scale_image(x1, y1, x2, y2)
    aspect_ratio = x1.to_f / y1.to_f
    screen_ratio = x2.to_f / y2.to_f

    if x1 > x2 or y1 > y2 then
        if aspect_ratio <= 1 then                   # vertical image
            height = y2.to_f
            width = height * aspect_ratio
        else                                        # horizontal image
            width = x2.to_f
            height = width / aspect_ratio
        end

        if width.to_i > x2 or height.to_i > y2 then
            width.to_i
        end

        while width.to_i > x2 or height.to_i > y2 do
            width *= 0.98
            height *= 0.98
        end

        return width.to_i, height.to_i
    else
        return x1, y1
    end
end

def center_image(w, h, x2, y2)
    q = x2 - w
    q = q / 2

    r = y2 - h
    r = r / 2

    return q, r
end
