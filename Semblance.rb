Shoes.app(title: "Semblance", width: 1200, height: 800) do
    background "#7A1D1F"
    title("Semblance",
    top: 60,
    align: "center",
    font: "Century Gothic",
    stroke: white)

    $accepted_exts = [".jpg", ".bmp", ".png", ".gif"]

	flow(margin_left:'38%', margin_top:'75%'){

        selected_folder = nil

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
                @slide_length = 0
                @current_index = 0
                @folder = ''
                @screen_width = 1280
                @screen_height = 800

                stack() {
                    slideshow_start(selected_folder, false, 3)
                    x1 = 0
                    y1 = 0

                    slide = image(next_image)
                    x1, y1 = scale_image(slide.full_width, slide.full_height, @screen_width, @screen_height)
                    w, h = center_image(x1, y1, @screen_width, @screen_height)
                    slide.style(:width => x1, :height => y1, :displace_left => w, :displace_top => h)

                    every(@slide_length) do
                        slide.path = next_image
                        x1, y1 = scale_image(slide.full_width, slide.full_height, @screen_width, @screen_height)
                        w, h = center_image(x1, y1, @screen_width, @screen_height)
                        slide.style(:width => x1, :height => y1, :displace_left => w, :displace_top => h)
                    end

                    keypress do |k|
                        if (k.inspect == ":right") then
                            slide.path = next_image
                            x1, y1 = scale_image(slide.full_width, slide.full_height, @screen_width, @screen_height)
                            w, h = center_image(x1, y1, @screen_width, @screen_height)
                            slide.style(:width => x1, :height => y1, :displace_left => w, :displace_top => h)
                        end

                        if (k.inspect == ":left") then
                            slide.path = prev_image
                            x1, y1 = scale_image(slide.full_width, slide.full_height, @screen_width, @screen_height)
                            w, h = center_image(x1, y1, @screen_width, @screen_height)
                            slide.style(:width => x1, :height => y1, :displace_left => w, :displace_top => h)
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
    while (accepted_exts.include? File.extname(cur_image_path)) do
        return(folder + "/" + cur_image_path)
    end
end

def slideshow_start(folder, shuffle_set, slide_length)
    @original_images_list = Dir.entries(folder).select {|f| !File.directory? f}
    @images_length = @original_images_list.length
    if (shuffle_set) then
        @shuffled_images_list = @original_images_list.shuffle
        @shuffle = shuffle_set
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


# TODO remove this from method so that I can call this on every image
# Not sure if this actually works in Ruby (calling displace and stuff)
def center_image(w, h, x2, y2)
    q = x2 - w
    q = q / 2

    r = y2 - h
    r = r / 2

    return q, r
end

# TODO Use an INI or something like it to store configuration settings
# Flow of configurations:
    # Start up  --  Will include a new menu for configuring the INI
    # Check for INI with config settings
    #     Not there: create a new INI

    # INI Configuration Options
