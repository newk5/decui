class CanvasCircle extends Component {
    className = "circle";
    xcenter =null;
    ycenter = null;
    points = null;
    border = null;
    color = null;
    radius = null;
    lines = null;
    Position = null;
    align = null;
    move = null;

    adjustedPos = null;
    mouseTimer = null;


    constructor(o) {
        this.points =  [];
        this.lines = [];

        local radius = 100;  
        this.xcenter = radius;
        this.ycenter = radius;
        this.radius = radius;
        
        
        this.border = 2;
        this.color = ::Colour(255,0,0);

        if (o.rawin("Position")){
            this.xcenter = o.Position.X;
             this.ycenter = o.Position.Y;
             this.Position = o.Position;
        }

        if (o.rawin("radius")){
            this.radius = o.radius;
        }
        if (o.rawin("border")){
            this.border = o.border;
        }
         if (o.rawin("color")){
            this.color = o.color;
        }
        this.id = o.rawin("id") ? o.id : Script.GetTicks()+"_circle" 
        local c = UI.Canvas({
         id = this.id
                
            Size = VectorScreen((radius*2)+border,radius*2+border)
            Position =VectorScreen(xcenter-radius,ycenter-radius),
            context = this
        });

        adjustedPos = false;
        if (o.rawin("align")){
            this.align = o.align;
            c.align =o.align;
            c.realign();
            adjustedPos = true;
        }

        if (o.rawin("move")){
            this.move = o.move;
            c.move =o.move;
            c.shiftPos();
             adjustedPos = true;
        }else{
            move = {};
        }
        if (adjustedPos){
            this.xcenter = c.Size.X /2;
            this.ycenter =  c.Size.Y/2;
        }else{
            this.xcenter = c.Size.X /2;
            this.ycenter =  c.Size.Y/2;
        }
        
        
        base.constructor(this.id);
        this.drawCircle(radius,radius, radius,c);
      
        
    
    }

    function drawCircle(xcenter, ycenter, radius,c){
      
        local x=0;
        local y=radius;
        local d= 3 - 2*radius;
        this.drawPx(xcenter,ycenter,x,y,c);
        while(y>=x){
            x++;
            if(d>0){
                y--;
                d = d + 4 * (x - y) + 10; 
               
            } else {
                  d = d + 4 * x + 6; 
            }
           this.drawPx(xcenter,ycenter,x,y,c);
        }
    }

    function drawPx(xc, yc, x, y,c){
 
        setPixel(xc+x, yc+y,c); 
        setPixel(xc-x, yc+y,c); 
        setPixel(xc+x, yc-y,c); 
        setPixel(xc-x, yc-y,c); 
        setPixel(xc+y, yc+x,c); 
        setPixel(xc-y, yc+x,c); 
        setPixel(xc+y, yc-x,c); 
        setPixel(xc-y, yc-x,c);
    }

    function setPixel(x, y,c) {
        local point = GUICanvas();
        point.Colour = this.color;
        point.Size = VectorScreen(this.border,this.border);
        point.Position = VectorScreen(x,y);

        this.points.push(point);
        
        c.AddChild(point);
    }

    function root( x) {
        if (x == 0) return 0;
        local last = 0.0;
        local res = 1.0;
        while (res != last) {  
            last = res;
            res = (res + x / res) / 2;
        }
        return res;
    }

    function attachToMouse(){
        if (this.mouseTimer == null){
            this.mouseTimer = Timer.Create(::getroottable(), function(text, canvas) {
           
                local pos = ::GUI.GetMousePos();
                if (pos != null && pos.X != null && pos.Y != null){
                    pos.Y -= canvas.radius;
                    pos.X -= canvas.radius;
                    canvas.setPosition(pos);
                }
                
            }, 1, 0, this.id+"_mouseFollower"+Script.GetTicks(), ::UI.Circle(this.id));
        }
      
    }

    function detachFromMouse(){
        Timer.Destroy(this.mouseTimer);
        this.mouseTimer = null;
    }

    function drawLine(xStart,yStart,xEnd,yEnd, color,c){
        local line = GUICanvas();
        line.Colour = color;
        line.Size = VectorScreen((xEnd-xStart)-this.border, 1)
        
       
         c.AddChild(line);

         line.Position = VectorScreen(xStart+this.border,yStart);

        this.lines.push(line);
    
    }

    function setPosition(pos){
         UI.Canvas(this.id).Position = pos;  
    }

    function fill(color){
        local c = UI.Canvas(this.id);
        local r2 =  this.radius * this.radius; 

        for (local cy = -radius; cy <= radius; cy++) {
            local cx = root(r2 - cy * cy) + 1;
            this.drawLine(xcenter - cx, ycenter-cy, xcenter + cx, ycenter+cy, color,c); 
        }

    }
    function cross(o){
        local color =  o.rawin("color") ? o.color : Colour(255,0,0);
        local size = o.rawin("size") ? o.size : 2;
        local c = UI.Canvas(this.id);


        local h = UI.Canvas({
            id = this.id+"_cross_h"
            Size = VectorScreen(c.Size.X, size)  
            Colour = color
            align ="mid_left"    
        })
     
        c.add(h);
        h.realign();

         local v = UI.Canvas({
            id = this.id+"_cross_v"
            Size = VectorScreen(size, c.Size.Y)  
            Colour = color 
            align ="top_center"    
        })
         c.add(v);
         v.realign();
        

    }
    function removeFill(){
        this.lines = [];
    }
}


 

