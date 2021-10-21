class PopUp extends DecUIComponent {

    className =  "Popup";

    text = null;
    size = null;

    onYes = null;
    onNo = null;
    onClose = null;
    yesText =  null;
    noText = null;


    constructor(o) {
        base.constructor(o);



        if (o.rawin("text") && o.text != null){
            this.text =o.text;
        }else{
             this.text = "Are you sure?";
        }
        if (o.rawin("yesText") && o.yesText != null){
            this.yesText =o.yesText;
        }else{
             this.yesText = "YES";
        }
         if (o.rawin("noText") && o.noText != null){
            this.noText =o.noText;
        }else{
             this.noText = "NO";
        }
        if (o.rawin("size") && o.size != null){
            this.size =o.size;
        }
        if (o.rawin("onYes") && o.onYes != null){
            this.onYes =o.onYes;
        }
         if (o.rawin("onClose") && o.onClose != null){
            this.onClose =o.onClose;
        }
         if (o.rawin("onNo") && o.onNo != null){
            this.onNo =o.onNo;
        }



        this.build();

    }



    function build(){

        local c = UI.Canvas({
            id = this.id,
            presets = this.presets
            Size = this.size == null ? VectorScreen(250, 120) : this.size,
            align = "center",
            context = this,
            Color = Colour(0,0,0,200),
            children = [
                UI.Sprite({
                    id= this.id+"::closeSprite",
                    file = "decui/closew.png",
                    align = "top_right" ,
                    context = this,
                    Size =VectorScreen(18,18),
                    move = {down = 10, left = 10 },
                    onClick = function(){
                        if (this.context.onClose != null){
                            this.context.onClose();
                        }
                        UI.DeleteByID(this.parents[this.parents.len()-1]);
                    }
                }),
                UI.Button({
                    id= this.id+"::popup::window::yesBtn",
                    Text =this.yesText,
                    context = this,
                    align = "bottom_right",
                    move = { left = 10, up = 10},
                    Colour = Colour(0,120,0),
                    FontSize = 13,
                    fontFlags = GUI_FFLAG_BOLD,
                    TextColor = Colour(255,255,255),
                     onClick = function(){
                        if (this.context.onYes != null){
                            this.context.onYes();
                        }
                         if (this.context.onClose != null){
                            this.context.onClose();
                        }
                       UI.DeleteByID(this.parents[this.parents.len()-1]);
                    }
                }),
                 UI.Button({
                    id= this.id+"::popup::window::noBtn",
                    Text = this.noText,
                    context = this,
                    align = "bottom_right",
                    move = { left = 80, up = 10},
                    Colour = Colour(160,0,0),
                    FontSize = 13,
                    fontFlags = GUI_FFLAG_BOLD,
                    TextColor = Colour(255,255,255),
                     onClick = function(){
                        if (this.context.onNo != null){
                            this.context.onNo();
                        }
                         if (this.context.onClose != null){
                            this.context.onClose();
                        }
                        UI.DeleteByID(this.parents[this.parents.len()-1]);
                    }
                }),
                UI.Label({
                    id = this.id+"::popup::window::label",
                    Text= this.text,
                    FontSize = 23,
                    fontFlags =GUI_FFLAG_OUTLINE | GUI_FFLAG_BOLD,
                    align="center",
                    move = {up = 20, left = 15},
                    TextColor = Colour(255,255,255)
                })
            ]
        });
        c.SendToTop();

    }


}

UI.registerComponent("Popup", {
    create = function(o) {
        local c = PopUp(o);
        return c;

    }
});