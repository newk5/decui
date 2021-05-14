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
    bindTo =null;
    direction = null;
    buttonAlign = null;
    buttonColour = null;
    Size = null;
    shadowID = null;
    setshadow = null;

    buttonWidth = 20;
    onValue = null;
    onSliderClicked = null;

constructor(o) {
        this.className = "Slider"; 
        this.id = o.id; 
        if (o.rawin("bindTo") && o.bindTo != null){
            ::UI.store.attachIDAndType(o.bindTo,o.id, "Slider");
            local val =  ::UI.store.get(o.bindTo);
            this.options = val;
            this.bindTo = o.bindTo;
        }

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
        this.build(null);
    }     

    
    function build(parent){
        if (parent != null){
            this.parentSize = parent.Size;
        } else{
            this.parentSize = GUI.GetScreenSize();
        }
        local parentsList = parent == null ? [] : parent.parents;
        if (parent != null) {
            parentsList.push(parent.id);
        }
        local childParents = [];
        foreach (idx, p in parentsList) { 
            childParents.push(p);
        }

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

        childParents.push(this.id);
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
        local s = ::getroottable().UI.Canvas(context.shadowID);
        local c = ::getroottable().UI.Canvas(this.id);
        local b = ::getroottable().UI.Canvas(this.squareID);

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

    value = function (value,debug=null) {
        local w,h;
        if (value != null) {
            local c = ::getroottable().UI.Canvas(this.id);
            local b = ::getroottable().UI.Canvas(this.squareID);
             
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

    shadow = function () {
        this.setshadow = true; 
        return this;
    }

    drag = function () {
        local b = ::getroottable().UI.Canvas(this.squareID);
        local c = ::getroottable().UI.Canvas(this.id);
        local s = ::getroottable().UI.Canvas(this.shadowID);
        
        if (this.onSliderClicked == true) {
            if (this.direction == "horizontal") { 
                local percent = (b.Pos.X.tofloat () / this.Size.X.tofloat () * 100).tointeger ();
                if (this.setshadow != null) this.value(percent,true); //adding shadow if activate
                if (GUI.GetMousePos () != null) {
                    b.Pos.X = GUI.GetMousePos ().X-c.Pos.X;
                    if (b.Pos.X <= 0) b.Pos.X = 0;
                    if (b.Pos.X >= c.Size.X - b.Size.X) b.Pos.X = c.Size.X - b.Size.X;
                }
                if (this.onValue != null) this.onValue (percent);                   
            }
            else { 
                local percent = (b.Pos.Y.tofloat () / this.Size.X.tofloat () * 100).tointeger ();
                if (this.setshadow != null) this.value(percent,true); //adding shadow if activate
                if (GUI.GetMousePos () != null) {
                    b.Pos.Y = GUI.GetMousePos ().Y-c.Pos.Y;
                    if (b.Pos.Y <= 0) b.Pos.Y = 0;
                    if (b.Pos.Y >= c.Size.Y - b.Size.Y) b.Pos.Y = c.Size.Y - b.Size.Y;
                }
               if (this.onValue != null) this.onValue (percent);              
            } 
        }
    }
} 