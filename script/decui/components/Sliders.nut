class Sliders extends Component {
    className = null;
    id = null;
    squareID = null;
    crossID = null;
    parentSize = null;
    Position = null;
    colour = null;
    move = null;
    border =null;
    align = null;
    direction = null;
    buttonAlign = null;
    buttonColour = null;
    Size = null;
    shadowID = null;
    setshadow = null;

    buttonWidth = 20;
    onValue = null;
    onSliderClicked = null;
    mouseTimer = null;

constructor(o) {
        this.className = "Slider"; 
        this.id = o.id; 

        if (o.rawin ("buttonWidth")) this.buttonWidth = o.buttonWidth;
        if (o.rawin ("buttonColour")) this.buttonColour = o.buttonColour;
        else this.buttonColour = Colour (0,0,0);
        
        if (o.rawin("direction")) this.direction = o.direction;
        else this.direction = "horizontal"

        if (o.rawin ("buttonAlign")){
            local a = this.direction == "vertical";
            if (o.buttonAlign == "left") a ? this.buttonAlign = "bottom" : this.buttonAlign = "mid_left"; 
            else if (o.buttonAlign == "right") a ? this.buttonAlign = "top_center" : this.buttonAlign = "mid_right"; 

            else this.buttonAlign = "left";
        }
        else this.buttonAlign = "left";
        
        if (o.rawin("onValue")) this.onValue = o.onValue;
        if (o.rawin("Size")) this.Size = o.Size;
        if (o.rawin("Colour")) this.colour = o.Colour;
        else this.colour = ::Colour(255,255,255);

        if (o.rawin("align")){
            this.align = o.align;
        }
        else this.align = "center";
        
        if (o.rawin ("setshadow")) this.setshadow = o.setshadow;
        if (o.rawin("border")){
            this.border = o.border;
        }

        if (o.rawin("move")) this.move = o.move; 
        else move = {};

        if (o.rawin("Position") && o.Position != null){
            this.Position = o.Position;
        }
        else this.Position = VectorScreen(0,0);

        this.squareID = this.id + "::Slider::square";
        this.crossID = this.id + "::Slider::cross";
        this.shadowID = this.id + "::Slider::shadowID";
        
        base.constructor(this.id,o);
        this.metadata.list = "sliders";
        this.build();
    }     

    
    function build(){
        local b = UI.Canvas({
            id= this.squareID,
            context = this,
            Color = this.buttonColour,   
            align = this.buttonAlign
            flags = GUI_FLAG_MOUSECTRL,
            onClick = function () {
                context.onSliderClicked = true;
            }

            onRelease = function (x,y) {
                context.onSliderClicked = false;
            }
        });

        local c = UI.Canvas({
            id=this.id,
            context = this,
            Color = this.colour, 
            Position = this.Position,  
            align = this.align,
            move = this.move,
            flags = GUI_FLAG_MOUSECTRL,
            onClick = function(){
                context.attachShadow ();
            }
        });

        local s = UI.Canvas({
            id=this.shadowID,
            context = this,
            Color = this.buttonColour,   
            align = this.buttonAlign
            flags = GUI_FLAG_MOUSECTRL,
            onClick = function(){
                context.attachShadow ();
            }
        });      

        local a = this.Size != null;
        if (this.direction == "horizontal") {
            a ? c.Size = this.Size : c.Size = VectorScreen (200,5);
            a ? b.Size = VectorScreen (c.Size.X/100*6,c.Size.Y+this.buttonWidth) : b.Size = VectorScreen (20,20); 
            s.Size = VectorScreen(0,this.Size.Y); 
           
            b.addBorders ({
                offset = 1
                color = this.buttonColour
            })
        } 
        else {
            a ? c.Size = VectorScreen (this.Size.Y,this.Size.X) : c.Size = VectorScreen (200,5);
            a ? b.Size = VectorScreen (this.Size.Y+this.buttonWidth,c.Size.Y/100*6) : b.Size = VectorScreen (20,20); 
            s.Size = VectorScreen(this.Size.Y,0); 
             
            b.addBorders ({
                offset = 1
                color = this.buttonColour
            })
        }

        if (this.border != null) {
            c.addBorders(this.border) 
        }

        c.shiftPos ();

        c.add(b, false);
        c.add(s, false);
        c.realign();

        return c; 
    }

    attachShadow = function (w=null,h=null,debug=null) {
        local context = this;
        local s = ::UI.Canvas(context.shadowID);
        local c = ::UI.Canvas(this.id);
        local b = ::UI.Canvas(this.squareID);

        if (context.direction == "horizontal") {
            local percent;
            if (context.buttonAlign == "mid_left") {
                if (GUI.GetMousePos () != null) b.Pos.X = GUI.GetMousePos ().X - c.Pos.X;
                if (context.setshadow != null) { 
                    if(w == null) s.Size.X = GUI.GetMousePos ().X - c.Pos.X;
                    else s.Size.X = w;

                    s.Pos.X = 0;
                }
                percent = (b.Pos.X.tofloat ()/c.Size.X.tofloat ()) * 100;
            }
            else {
                if (GUI.GetMousePos () != null) b.Pos.X = GUI.GetMousePos ().X - c.Pos.X;
                if (context.setshadow != null) { 
                    if(w == null) s.Size.X = context.Size.X-b.Pos.X;
                    else if (debug) s.Size.X = w;
                    else s.Size.X = context.Size.X-w;

                    s.Pos.X = c.Size.X - s.Size.X;
                }
                percent = 100-(b.Pos.X.tofloat ()/c.Size.X.tofloat ()) * 100;
            }
            if (context.onValue != null && w == null) context.onValue (percent.tointeger ());
        } 
        else {
            local percent;
            if (context.buttonAlign == "bottom") {
                if (GUI.GetMousePos () != null) b.Pos.Y = GUI.GetMousePos ().Y - c.Pos.Y;
                if (context.setshadow != null) {   
                    if(h == null) s.Size.Y = context.Size.X-b.Pos.Y;
                    else if (debug) s.Size.Y = h;
                    else s.Size.Y = context.Size.X-h; 

                    s.Pos.Y = c.Size.Y - s.Size.Y;     
                }
                percent = (b.Pos.Y.tofloat ()/c.Size.Y.tofloat ()) * 100;
            }
            else {
                if (GUI.GetMousePos () != null) b.Pos.Y = GUI.GetMousePos ().Y - c.Pos.Y;
                if (context.setshadow != null) {
                    if(h == null) s.Size.Y = GUI.GetMousePos ().Y - c.Pos.Y;
                    else s.Size.Y = h; 

                    s.Pos.Y = 0;
                }
                percent = 100-(b.Pos.Y.tofloat ()/c.Size.Y.tofloat ()) * 100;
            }
            if (context.onValue != null && h == null) context.onValue (percent.tointeger ());
        }
        return this;
    }

    setValue = function (value,debug=null) {
        local w,h;
        if (value != null) {
            local c = ::UI.Canvas(this.id);
            local b = ::UI.Canvas(this.squareID);
             
            if (this.direction == "horizontal") { 
                local percent = c.Size.X.tofloat () / 100 * value;
                if (this.buttonAlign == "mid_left") {
                    if (b.Pos.X <= c.Size.X - b.Size.X) b.Pos.X = percent;
                    w = b.Pos.X;
                } 
                else {
                    if (b.Pos.X >= 0) b.Pos.X = c.Size.X.tofloat ()-percent.tofloat()
                    w = b.Pos.X;
                }
                if (this.onValue != null) this.onValue (value > 100 ? 100 : value);                
            }
            else { 
                local percent = c.Size.Y.tofloat () / 100 * value;
                if (this.buttonAlign == "bottom") {
                    if (b.Pos.Y >= 0) b.Pos.Y = c.Size.Y.tofloat ()-percent.tofloat()
                    h = b.Pos.Y;
                } 
                else {
                    if (b.Pos.Y <= c.Size.Y - b.Size.Y) b.Pos.Y = percent;   
                    h = b.Pos.Y;
                }
                if (this.onValue != null) this.onValue (value > 100 ? 100 : value);              
            } 
        }
        this.attachShadow (w,h,debug); 
        return this;
    }

    attachToShadow = function () {
        this.setshadow = true; 
        return this;
    }

    attachToMouse = function () {
        if (this.mouseTimer == null ) {
            this.mouseTimer = Timer.Create (::UI, function (squareId,Id,shadowId) {
                local b = ::UI.Canvas(squareId);
                local c = ::UI.Canvas(Id);
                local s = ::UI.Canvas(shadowId);
                local context = ::UI.Slider(Id)

                if (context.onSliderClicked == true) {
                    if (context.direction == "horizontal") { 
                        local percent = (b.Pos.X.tofloat () / context.Size.X.tofloat () * 100).tointeger ();
                        if (context.setshadow != null) context.setValue(percent,true); //adding shadow if activate
                        if (GUI.GetMousePos () != null) {
                            b.Pos.X = GUI.GetMousePos ().X-c.Pos.X;
                            if (b.Pos.X <= 0) b.Pos.X = 0;
                            if (b.Pos.X >= c.Size.X - b.Size.X) b.Pos.X = c.Size.X - b.Size.X;
                        }
                        if (context.onValue != null) context.onValue (percent);                   
                    }
                    else { 
                        local percent = (b.Pos.Y.tofloat () / context.Size.X.tofloat () * 100).tointeger ();
                        if (context.setshadow != null) context.setValue(percent,true); //adding shadow if activate
                        if (GUI.GetMousePos () != null) {
                            b.Pos.Y = GUI.GetMousePos ().Y-c.Pos.Y;
                            if (b.Pos.Y <= 0) b.Pos.Y = 0;
                            if (b.Pos.Y >= c.Size.Y - b.Size.Y) b.Pos.Y = c.Size.Y - b.Size.Y;
                        }
                        if (context.onValue != null) context.onValue (percent);              
                    }    
                }             
            }, 1, 0, this.squareID, this.id, this.shadowID)
        }
    }

    function detachFromMouse(){
        if (Timer.Exists (this.mouseTimer)) Timer.Destroy(this.mouseTimer);
        this.mouseTimer = null;
    }    
} 