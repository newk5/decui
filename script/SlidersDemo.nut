        UI.Slider({
            id = "sliderDemoID"
            direction = "vertical"  //
            align = "center"
            buttonAlign = "right" //left | right
            buttonColour = Colour (255,0,2)
            buttonWidth = 20 // button width
            Size = VectorScreen (500,100) 

            onValue = function (value) {
              Console.Print(value)
            }    
        }) 

        // value - function (integer 0 - 100);
        // shadow - function
        // drag - place this on scriptprocess  
