Shoes.app(title: "Semblance", width: 1200, height: 800) do
    background "#7A1D1F"
    title("Semblance",
    top: 60,
    align: "center",
    font: "Century Gothic",
    stroke: white)

    @folder = nil 

	# top:"700", left:"530"
	flow(){
        style(margin_left:'38%', margin_top:'75%')

	    button("Select Folder") {
          @folder = ask_open_folder()
        }

        button("Start Semblance") {
            
        }
	}


	

end
