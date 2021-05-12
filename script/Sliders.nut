class Sliders extends Component {
    className = null;
    id = null;
    value = null; 
    squareID= null;
    parentSize = null;
    canvasSize = null;
    Position = null;
    colour = null;
    move = null;
    height =  null;
    border =null;
    align = null;
    bindTo =null;
    direction = null;
    buttonAlign = null;
    buttonColour = null;
    Size = null;

constructor(o) {
        this.className = "Slider"; 
        this.id = o.id; 
        if (o.rawin("bindTo") && o.bindTo != null){
            ::UI.store.attachIDAndType(o.bindTo,o.id, "Slider");
            local val =  ::UI.store.get(o.bindTo);
            this.options = val;
            this.bindTo = o.bindTo;
        }

        if (o.rawin ("buttonColour")) this.buttonColour = o.buttonColour;
        else this.buttonColour = 0;
        
        if (o.rawin("direction")) this.direction = o.direction;
        else this.direction = "horizontal"

        if (o.rawin ("buttonAlign")){
            local a = this.direction == "vertical";
            if (o.buttonAlign == "center") this.buttonAlign = "center";  
            else if (o.buttonAlign == "left") a ? this.buttonAlign = "bottom" : this.buttonAlign = "mid_left"; 
            else if (o.buttonAlign == "right") a ? this.buttonAlign = "top_center" : this.buttonAlign = "mid_right"; 

            else this.buttonAlign = "center";
        }
        else this.buttonAlign = "center";

        this.colour = ::Colour(255,255,255);
        if (o.rawin("Size") && o.Size != null){
            this.Size =o.Size;
        }
        if (o.rawin("Colour") && o.Colour != null){
            this.colour =o.Colour;
        }

        if (o.rawin("align")){
            this.align = o.align;
        }
        else this.align = "center";
        
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
            Size = VectorScreen (20,20),
            Color = this.buttonColour,   
            align = this.buttonAlign
            flags = GUI_FLAG_MOUSECTRL,
            onClick = function(){
            }
        });

        childParents.push(this.id);
        local c = UI.Canvas({
            id=this.id,
            context = this,
            Color = Colour (255,255,255), 
            Position = this.Position,  
            align = this.align,
            move = this.move,
            flags = GUI_FLAG_MOUSECTRL,
            onClick = function(){
                if (context.direction == "horizontal") b.Pos.X = GUI.GetMousePos ().X - this.Pos.X;
                else b.Pos.Y = GUI.GetMousePos ().Y - this.Pos.Y;
            }
        });

        local a = this.Size != null;
        if (this.direction == "horizontal") {
            a ? c.Size = this.Size : c.Size = VectorScreen (200,5);
            a ? b.Size = VectorScreen (c.Size.X/100*6,c.Size.X/100*6) : b.Size = VectorScreen (20,20); 
        }
        else {
            a ? c.Size = VectorScreen (this.Size.Y,this.Size.X) : c.Size = VectorScreen (200,5);
            a ? b.Size = VectorScreen (c.Size.Y/100*6,c.Size.Y/100*6) : b.Size = VectorScreen (20,20); 
        }

        if (this.border != null) {
            c.addBorders(this.border) 
        }

        b.realign ();
        c.shiftPos ();

        c.add(b, false);
        c.realign();
        return c;
    }
}