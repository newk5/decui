class UINotification extends DecUIComponent {

    className = "Notification";
    Size = null; //min-size
    Colour = null;
    border = null;
    title = null;
    text = null;
    timer = null;
    time = null;
    type = null;
    autoSize = null;

    constructor(o) {
        base.constructor(o);
        this.Colour = o.rawin("Colour") ? o.Colour : ::Colour(82,175,79,150);
        this.title = o.rawin("title") ? o.title : "";
        this.text = o.rawin("text") ? o.text : "";
        this.time = o.rawin("time") ? o.time : 5.0;
        this.autoSize = o.rawin("autoSize") ? o.autoSize : false;
        this.Size = o.rawin("Size") ? o.Size : VectorScreen(250, 90 );
        this.type = o.rawin("type") ? o.type : "success";

        if (this.type.tolower() == "warning"){
            this.Colour = ::Colour(208,187,50,150);
        } else if (this.type.tolower() == "error"){
            this.Colour = ::Colour(186,66,66,150);
        } else if (this.type.tolower() == "info"){
            this.Colour = ::Colour(0,174,255,120);
        }


        this.border = o.rawin("border") ? o.border : { color = ::Colour(255,255,255), size =1 };



        this.build();

    }


    function build() {
       // UI.Cursor("ON")
        local l = UI.Label({
            id = this.id+"_labelTitle"
            Text = this.title
            fontFlags = GUI_FFLAG_BOLD
            FontSize = 15
            align = "top_left"
            TextColour = ::Colour(255,255,255)
            move = {
                down = "15%"
            }
            Alpha = 200
        })

         local lText = UI.Label({
            id = this.id+"_labelText"
            Text = this.text
            fontFlags = GUI_FFLAG_BOLD
            FontSize = 12
            align = "center"
            TextColour = ::Colour(255,255,255)
            move = {
                down = "10%"
            }
            Alpha = 200
        })
        local sizeX = lText.Size.X > l.Size.X ? lText.Size.X : l.Size.X;
        if (this.Size.X > sizeX && !autoSize){
            sizeX = this.Size.X;
        }
        if (autoSize){
            this.Size.X = sizeX;
        }
        local mup = 4;
        if (::UI.openNots > 0){
            mup = (::UI.notsHeight +4)+1;
        }
        ::UI.notsHeight = mup;
        mup = mup+"%";
        local c =  UI.Canvas({
            id = this.id
            presets = this.presets
            Size = this.Size
            autoResize = true
            Colour = this.Colour
            align = "bottom_right"

        })


        local titleHeader = UI.Canvas({
            id = this.id+"_headerCanvas"
            Colour = ::Colour(0,0,0,150)
            autoResize = true
            align = "top_left"
            Size = VectorScreen(sizeX, l.Size.Y+15)

        });


        c.add(titleHeader, false);
        c.add(lText, false);
        titleHeader.add(l, false);
        local cl = UI.Sprite({
            id=this.id+"_closeBtn"
            file ="decui/closeb.png",
            align = "top_right"
            context = this
            onClick = function() {
               local c = UI.Canvas(context.id);
               if (c != null){
                   if (context.timer != null){
                        ::Timer.Destroy(context.timer);
                   }
                   ::UI.openNots--;
                   ::UI.notsHeight -= 12;
                   c.destroy();


               }
            }
            Size = VectorScreen(21,21),
            move = {
                down = "18%"
                left = "2%"
            }
        });
        titleHeader.add(cl, false);

        cl.resetMoves();
        c.Size.X+= 30;
        titleHeader.Size.X+= 30;
        c.move = {
            up= mup
            left = "2%"
        };
        cl.realign();
        cl.shiftPos();
        cl.SendToTop();
        titleHeader.addBorders({size = 2, color = ::Colour(0,0,0,255)});
        c.addBorders({size = 2, color = ::Colour(0,0,0,255)});

        local bar = UI.Canvas({
            id = this.id+"_bar"
            Size = VectorScreen(c.Size.X, 10)
            Colour = titleHeader.Colour
            align = "bottom_left"
        })
        c.add(bar, false);
        c.shiftPos();
       ::UI.openNots++;
       local d = (bar.Size.X/time).tofloat();

        this.timer= Timer.Create(this, function(bar,d) {

           if (bar.Size.X <= 0){


              try {

                    ::Timer.Destroy(this.timer);

                    local c = UI.Canvas(this.id);

                    if (c != null){
                        c.destroy();
                        if (UI.showDebugInfo){
                            UI.decData("notifications");
                        }
                        ::UI.openNots--;
                        ::UI.notsHeight -= 12;
                    }
                    ::GUI.SetFocusedElement(null);
                 } catch (exc){

                }
           }
            bar.Size.X -= d;
        }, 1000, 0,bar,d);



    }
}

UI.registerComponent("Notification", {
    create = function(o) {
        local c = UINotification(o);
        return c;

    }
});


