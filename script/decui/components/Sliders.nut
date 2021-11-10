class Sliders extends DecUIComponent {
    buttonId        = null;
    crossID         = null;
    Position        = null;
    colour          = null;
    border          = null;
    layout          = null;
 
    Size                     = null;
    TrackId                 = null;
    trackStatus             = null;
    trackColor              = null;
    tapToSeek               = null;

    onValueChange           = null;
    onSliderClicked         = null;
    mouseTimer              = null;
    getValue                = null;
    thumbStyle              = null;
    maximunValue            = null;
    onSlidingEnd            = null;
    onSlidingStart          = null;
    onSlideEvent            = null;
    stopTracks              = null;
    defaultValue            = null;

    constructor(o) {
        base.constructor(o);
        if (!this.maximunValue) this.maximunValue = 100;
        if (!this.defaultValue) this.defaultValue = 0;

        local orientation = this.layout == "vertical";
        if (this.thumbStyle.origin == "left") this.thumbStyle.origin = (orientation ? "bottom" : "mid_left");
        else this.thumbStyle.origin = (orientation ? "top_center" : "mid_right");
 
        if (o.rawin("Colour")) this.colour = o.Colour;
        else this.colour = ::Colour(255,255,255);

        this.buttonId = this.id + "::Slider::square";
        this.crossID = this.id + "::Slider::cross";
        this.TrackId = this.id + "::Slider::trackId";

        this.build();
    }

    function build(){
        local c         = UI.Canvas({
            id          = this.id,
            context     = this,
            Color       = this.colour,
            Position    = this.Position,
            Size        = this.Size,
            align       = this.align,
            move        = this.move,
            flags       = GUI_FLAG_MOUSECTRL,
            onClick     = function() { if (context.tapToSeek) context.assignTrackToParent (null, null, true); }
        });

        local b         = UI.Canvas({
            id          = this.buttonId,
            context     = this,
            Color       = this.thumbStyle.color,
            align       = this.thumbStyle.origin
            flags       = GUI_FLAG_MOUSECTRL,  
            onClick     = function () { 
                context.onSliderClicked = true; 
 
            }
            onRelease   = function (x,y) { 
                context.onSliderClicked = false; 
                if (context.onSlidingEnd && context.onSlideEvent) context.onSlidingEnd ();
                context.onSlideEvent = null;
            }
        });

        local s     = UI.Canvas({
            id      = this.TrackId,
            context = this,
            Color   = this.trackColor ? this.trackColor : Colour (255,0,0), 
            align   = this.thumbStyle.origin
            flags   = this.tapToSeek ? GUI_FLAG_NONE : GUI_FLAG_DISABLED,
            onClick = function() {
                if (context.tapToSeek) context.assignTrackToParent (null, null, true);
                context.onSliderClicked = true;
            }

            onRelease = function (x,y) { context.onSliderClicked = false;
                if (context.onSlidingEnd && context.onSlideEvent) context.onSlidingEnd ();
                context.onSlideEvent = null;
            }
        }); 

            // assigning properties to childs
        if (this.layout == "horizontal") {
                // button
            b.Size = VectorScreen (this.thumbStyle.height + (c.Size.X / 100) * 6, c.Size.Y + this.thumbStyle.width);
            s.Size.Y = this.Size.Y;
        }
        else {
                // assigning layout if is vertical
            c.Size = VectorScreen (this.Size.Y, this.Size.X);
            b.Size = VectorScreen (this.Size.Y + this.thumbStyle.width, this.thumbStyle.height + (c.Size.Y / 100) * 5);
                
                // track width
            s.Size.X = this.Size.Y
        }

        if (this.border != null) c.addBorders(this.border);


        c.shiftPos ();

        c.add(b, false);
        c.add(s, false);

        c.realign(); 

            // aligning button  
        if (this.layout == "horizontal") b.Pos.Y = -(this.thumbStyle.width/2);
        else b.Pos.X = -(this.thumbStyle.width/2);

        this.setValue (this.defaultValue)  
    }   
 
    assignTrackToParent = function (w=null, h=null, pressed = null) {
        local context = this;
        local s = ::UI.Canvas(context.TrackId); 
        local c = ::UI.Canvas(this.id);
        local b = ::UI.Canvas(this.buttonId);
        
        if (context.layout == "horizontal") {
                // horizontal
            local percent;
            if (this.thumbStyle.origin == "mid_left") {
                    // assigning position depending on where the click was.
                if (pressed && GUI.GetMousePos () != null) b.Pos.X = GUI.GetMousePos ().X - c.Pos.X;

                    // trackstatus
                if (context.trackStatus) {
                    if (!w && GUI.GetMousePos ()) s.Size.X = (GUI.GetMousePos ().X - c.Pos.X);
                    else s.Size.X = w;
 
                    s.Pos.X = 0;
                }
                percent = (b.Pos.X.tofloat ()/c.Size.X.tofloat ()) * context.maximunValue;
            }
            else {
                    // assigning position depending on where the click was.
                if (pressed && GUI.GetMousePos () != null) b.Pos.X = GUI.GetMousePos ().X - c.Pos.X; 

                    // trackstatus
                if (context.trackStatus) {
                        // depending on canvas click position
                    if(!w) s.Size.X = (context.Size.X-b.Pos.X) - b.Size.X;
                    
                        // adapting position by value
                    else s.Size.X = context.Size.X-w;

                        //  positioning
                    s.Pos.X = c.Size.X - s.Size.X;
                }
                percent = context.maximunValue - (b.Pos.X.tofloat ()/c.Size.X.tofloat ()) * context.maximunValue;
            }
            context.percentProvider (floor (percent));
        }
        else {
                // vertical
            local percent;
            if (this.thumbStyle.origin == "bottom") {
                    // assigning position depending on where the click was.
                if (pressed && GUI.GetMousePos () != null) b.Pos.Y = (GUI.GetMousePos ().Y - c.Pos.Y);

                    // trackstatus
                if (context.trackStatus) {
                    if(!h) s.Size.Y = (context.Size.X-b.Pos.Y) - b.Size.Y;
                    else s.Size.Y = (context.Size.X-h);

                    s.Pos.Y = c.Size.Y - s.Size.Y;
                }
                percent = context.maximunValue-(b.Pos.Y.tofloat ()/c.Size.Y.tofloat ()) * context.maximunValue;
            }
            else {
                    // assigning position depending on where the click was.
                if (pressed && GUI.GetMousePos () != null) b.Pos.Y = GUI.GetMousePos ().Y - c.Pos.Y;
               
                    // trackstatus
                if (context.trackStatus) {
                    if(!h && GUI.GetMousePos ()) s.Size.Y = GUI.GetMousePos ().Y - c.Pos.Y;
                    else s.Size.Y = h;

                    s.Pos.Y = 0;
                }
                percent = (b.Pos.Y.tofloat ()/c.Size.Y.tofloat ()) * context.maximunValue;
            }
            context.percentProvider (floor (percent));
        }
        return this;
    }

    percentProvider = function (percent) {
        if (this.onValueChange != null) this.onValueChange (percent);
        this.getValue = (percent);
    }

    setValue = function (value) {
        if (value >= this.maximunValue) value = this.maximunValue;
        if (value < 0) value = 0;

        value = value-1;

        local w, h;
        if (value != null) {
            local c = ::UI.Canvas(this.id);
            local b = ::UI.Canvas(this.buttonId);
  
            if (this.layout == "horizontal") {  
                    // horizontal layout
                local percent = floor (c.Size.X.tofloat () / this.maximunValue * value);

                if (this.thumbStyle.origin == "mid_left") {
                    b.Pos.X = percent;
                    w = b.Pos.X;

                   
                }
                else {
                    b.Pos.X = (c.Size.X-percent) - b.Size.X;
                    w = b.Pos.X + b.Size.X;
                }
            }
            else {
                    // vertizal loyout
                local percent = floor (c.Size.Y.tofloat () / this.maximunValue * value); 
                if (this.thumbStyle.origin == "bottom") {
                    b.Pos.Y = (c.Size.Y-percent) - b.Size.Y;
                    h = b.Pos.Y + b.Size.Y;
                }
                else {
                    b.Pos.Y = percent;
                    h = b.Pos.Y;
                }
            }
 
            this.percentProvider (value);
        }

        this.assignTrackToParent (w, h);
        return this;
    }

    attachToMouse = function () {
        local context = this;
        if (this.mouseTimer == null ) { 
            local checkIfSliding = 0;
            this.mouseTimer = Timer.Create (::UI, function (buttonId,Id,TrackId) {
                local b = ::UI.Canvas(buttonId);
                local c = ::UI.Canvas(Id);
                local s = ::UI.Canvas(TrackId);
 
                if (context.onSliderClicked == true) {
                    checkIfSliding++;
                    if (context.layout == "horizontal") {
                        local percent = (b.Pos.X.tofloat () / context.Size.X.tofloat () * context.maximunValue).tointeger ();
                        if (GUI.GetMousePos () != null) {
                                // position button
                            if (context.tapToSeek || context.onSlideEvent) b.Pos.X = GUI.GetMousePos ().X-c.Pos.X;
                            if (b.Pos.X <= 0) b.Pos.X = 0;
                            if (b.Pos.X >= c.Size.X - b.Size.X) b.Pos.X = c.Size.X - b.Size.X;
                                
                                // tracks
                            if (context.trackStatus && context.tapToSeek || context.onSlideEvent && context.trackStatus) {
                                    
                                    // position track
                                if (context.thumbStyle.origin == "mid_right") {
                                    s.Pos.X     = (b.Pos.X-c.Size.X) + c.Size.X + b.Size.X;
                                    s.Size.X    = (c.Size.X-b.Pos.X) - b.Size.X;
                                    
                                    percent = context.maximunValue-percent;
                               
                                }
                                else {
                                        // position track
                                    s.Size.X = (GUI.GetMousePos ().X-c.Pos.X);

                                    if (s.Size.X <= 0) s.Size.X = 0;
                       
                                        // x axis
                                    if (s.Pos.X >= c.Size.X - s.Size.X - b.Size.X) {
                                        s.Size.X = c.Size.X - b.Size.X;
                                        percent = context.maximunValue;
                                    }
                                }
                                context.percentProvider (percent); 
                            } 
                            else {
                                if (context.thumbStyle.origin == "mid_right") context.percentProvider (context.maximunValue-percent);
                                else context.percentProvider (percent);
                            }   
                        }
                    }
                    else {  
                        local percent = floor (b.Pos.Y.tofloat () / c.Size.Y.tofloat () * context.maximunValue.tofloat ());

                            // fix percent giving wrong values
                        if (GUI.GetMousePos () != null) {
                                // positioning button
                                // button will only move if the onslideevent is declared as true or if tapToseek is true
                            if (context.tapToSeek || context.onSlideEvent) b.Pos.Y = (GUI.GetMousePos ().Y-c.Pos.Y);
                            if (b.Pos.Y <= 0) b.Pos.Y = 0;
                            if (b.Pos.Y >= c.Size.Y - b.Size.Y) b.Pos.Y = c.Size.Y - b.Size.Y;
                            
                                // tracks
                            if (context.trackStatus && context.tapToSeek || context.onSlideEvent && context.trackStatus) {
                                    
                                    // position track
                                if (context.thumbStyle.origin == "bottom") {
                                    s.Pos.Y     = (b.Pos.Y-c.Size.Y) + c.Size.Y + b.Size.Y;
                                    s.Size.Y    = (c.Size.Y-b.Pos.Y) - b.Size.Y;
 
                                    percent =  (context.maximunValue-percent);
                                    if (b.Pos.Y >= c.Size.Y- b.Size.Y) percent = 0;
                                }
                                else { 
                                        // position track
                                    s.Size.Y = (GUI.GetMousePos ().Y-c.Pos.Y) ;

                                    percent = 0
                                    if (b.Pos.Y >= c.Size.Y- b.Size.Y) percent = context.maximunValue;
                                }
                                context.percentProvider (percent); 
                            } 
                            else {
                                if (context.thumbStyle.origin == "bottom") context.percentProvider (context.maximunValue-percent);
                                else context.percentProvider (percent);
                            }
                        }
                    }
                }
                else checkIfSliding = 0;

                    // after 5 ms the user is sliding so let's start onsliding event.
                if (checkIfSliding > 5 && context.onSlidingStart != null) {
                    context.onSlidingStart (b.Pos.X, b.Pos.Y);
                    context.onSlideEvent = true;
                }
  
            }, 1, 0, this.buttonId, this.id, this.TrackId);
        }

        return this;
    }

    detachFromMouse = function (){
        if (Timer.Exists (this.mouseTimer)) Timer.Destroy(this.mouseTimer);
        this.mouseTimer = null;
    }
}

UI.registerComponent("Slider", {
    create = function(o) {
        local c = Sliders(o);
        return c;
    }
});