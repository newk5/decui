 UI.Menu({
    id="menu" 
    padding = 3
    layout = "vertical"
    onClick = function (canvas, label) {
        local option = label.Text;
        Console.Print("clicked option "+option);
    }
    onHoverOut = function (canvas, label) {
    }
    labelStyle = {
       // TextColour = Colour(255,0,0,255)
    }
    options = [
        { 
            label = "test"
        },
       { 
            label = "test33", 
            style = { 
               // border = {  size = 5 }
                TextColour = ::Colour(50,10,100)
                onHover = { 
                    border = { size = 2} 
                    label = {
                        TextColour = ::Colour(255,100,255)
                        FontSize = 25
                    }
                } 
            } 
        }
        { label = "test"} ,
        { label = "test"} ,
        { label = "test"}
    ]
});