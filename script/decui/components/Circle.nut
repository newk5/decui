class CanvasCircle extends DecUIComponent {
    className = "circle";
    xcenter =null;
    ycenter = null;
    points = null;
    border = null;
    color = null;
    radius = null;
    lines = null;
    crossPoints = null;
    plusPoints = null;


    adjustedPos = null;
    mouseTimer = null;

    plusDrawnFlag = null;
    crossDrawnFlag = null;
    label = null;


    constructor(o) {
        base.constructor(o);
        this.points =  [];
        this.lines = [];
        this.crossPoints = [];

        this.xcenter = 100;
        this.ycenter = 100;
        this.radius = 100;

        plusDrawnFlag = false;
        crossDrawnFlag = false;

        this.border = 2;
        this.color = ::Colour(255,255,255);

        if (o.rawin("Position")){
            this.xcenter = o.Position.X;
             this.ycenter = o.Position.Y;
             this.Position = o.Position;
        }

        if (o.rawin("label")){
            this.label = o.label;
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
            presets = this.presets
            Size = VectorScreen((radius*2)+border,radius*2+border)
            Position =VectorScreen(xcenter-radius,ycenter-radius),
            context = this
        });
        if (o.rawin("flags")) {
            c.AddFlags(o.flags);
        }
        if (o.rawin("Transform3D")){
            local pos = o.Transform3D.rawin("Position3D") ? o.Transform3D.Position3D : Vector(0,0,0);
            local rot = o.Transform3D.rawin("Rotation3D") ? o.Transform3D.Rotation3D : Vector(-1.6, 0.0, 0);
            local size = o.Transform3D.rawin("Size3D") ? o.Transform3D.Size3D : Vector(2, 2, 0.0);
            c.Set3DTransform(pos, rot, size);
        }
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

        this.xcenter = c.Size.X /2;
         this.ycenter =  c.Size.Y/2;




        this.drawCircle(radius,radius, this.radius,c);
        if (o.rawin("crossed") && o.crossed){
            this.cross(c);
        }
        if (this.label != null){
            if (typeof this.label == "string"){
                local l = UI.Label({
                    id = this.id+"::label"
                    Text = this.label
                    align = "center"
                    move = {up = 3, left = 3}
                    TextColour = Colour(255,255,255)
                    FontSize = 35
                });
                c.add(l);

            }else{
                this.label["id"] <- this.id+"::label";
                c.add(UI.Label(this.label));
            }
        }


    }

    function cross(o){
        if (!crossDrawnFlag){
            crossDrawnFlag=true;
            local x1  = xcenter - (this.radius/1.45);
            local x2 = xcenter+(this.radius/1.45);

            local y1 = ycenter - (this.radius/1.45);
            local y2 = ycenter +(this.radius/1.45);

            bresenham(x1, x2, y2, y1,o);
            bresenham2(x1, x2, y1, y2,o);
        }

    }

    function bresenham(x1, x2, y1, y2,o)  {

        local m_new = 2 * (y2 + y1);
        local slope_error_new = m_new + (x2 + x1);
        local c = UI.Canvas( this.id);
        for (local x = x1, y = y1; x <= x2; x++)
        {

            setPixelCross(x, y, c,o);
            // Add slope to increment angle formed
            slope_error_new -= m_new;

            // Slope error reached limit, time to
            // increment y and update slope error.
            if (slope_error_new <= 0)
            {
                y--;
                slope_error_new += 2 * (x2 + x1);
            }
        }
    }
    function bresenham2(x1, x2, y1, y2,o)  {

        local m_new = 2 * (y2 - y1);
        local slope_error_new = m_new - (x2 - x1);
        local c = UI.Canvas( this.id);
        for (local x = x1, y = y1; x <= x2; x++)
        {

            setPixelCross(x, y, c,o);
            // Add slope to increment angle formed
            slope_error_new += m_new;

            // Slope error reached limit, time to
            // increment y and update slope error.
            if (slope_error_new >= 0)
            {
                y++;
                slope_error_new -= 2 * (x2 - x1);
            }
        }
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

     function setPixelCross(x, y,c, o) {
        local point = GUICanvas();
        point.Colour = o.rawin("color") ? o.color : this.color;
        point.Size = VectorScreen(o.rawin("size") ? o.size : this.border,o.rawin("size") ? o.size : this.border);
        point.Position = VectorScreen(x,y);

        this.crossPoints.push(point);

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
            this.mouseTimer = Timer.Create(::getroottable(), function(canvas) {

                local pos = ::GUI.GetMousePos();
                if (pos != null && pos.X != null && pos.Y != null){
                    pos.Y -= canvas.radius;
                    pos.X -= canvas.radius;
                    canvas.setPosition(pos);
                }

            }, 1, 0, ::UI.Circle(this.id));
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

    function plus(o){
        if (!plusDrawnFlag) {
            plusDrawnFlag = true;
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

    }
    function removeFill(){
        this.lines = [];
    }
    function removeCross(){
        this.crossPoints = [];
    }
    function removePlus(){
        local h = UI.Canvas(this.id+"_cross_h");
        if (h!=null) {
            h.destroy();
        }
        local v = UI.Canvas(this.id+"_cross_v");
        if (v!=null) {
            v.destroy();
        }

    }
}

UI.registerComponent("Circle", {
    create = function(o) {
        local c = CanvasCircle(o);
        return c;

    }
});


