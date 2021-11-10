   local e = UI.Slider({
            id              = "sliderDemoID"
            layout          = "vertical"  //
            align           = "radar_right"
            Size            = VectorScreen (150,30)
                // all thumbstyle properties are required
            thumbStyle      = {
                origin      = "left"
                width       = 10
                height      = 10
                color       = Colour (255, 0, 255)
            }
 
            maximunValue    = 20 // default: 100
            tapToSeek       = true // default: false
            trackColor      = Colour (255, 0, 0) // default: black
            trackStatus     = true

            defaultValue = 10  //default 0
            Colour           = Colour (255,255,255) // container colour
        })

    // properties
  //.attachToMouse () //- function;
 // .detachFromMouse () - function;
 // .setValue (percent 0-maximunValue) - function;   
 // .getValue - variable
 // .onValueChange (value) - function;
 // .onSlidingStart (x,y) - function;
 // .onSlidingEnd () - function;