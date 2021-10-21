class CanvasButton extends DecUIComponent {
    
    
    Size = null;
    Label = null;
    Text = null;
    Colour = null;
    CanvasPresets = null;
    LabelPresets = null;
    onClick = null;

    constructor(o) {
      base.constructor(o);
      this.build();
    }
    
    function build() {
        local labelInstance =null;
        if (this.Label == null){
            labelInstance = UI.Label({
                id = this.id+"::canvasButton::label"  
                Text = this.Text == null ? "": this.Text 
                align = "center"
                context = this
                presets = this.LabelPresets
                onClick = function() {
                    context.onClick();
                }
            })
        }else{
            this.Label["id"] <- this.id+"::canvasButton::label" ;
            this.Label["context"] <- this;
            this.Label["onClick"] <- function() {
                context.onClick();
            };
            labelInstance = UI.Label(this.Label);
        }
       local c =  UI.Canvas({
            id = this.id
            move = this.move
            align = this.align
            Colour = this.Colour == null ? ::Colour(255,255,255) : this.Colour
            Size = this.Size != null ? this.Size : VectorScreen(80, 25)
            autoResize=true
            Position = this.Position
            border = this.border
            context = this
            onClick = function() {
                context.onClick();
            }
        });
        c.add(labelInstance);
     
    }
    
    function onClick() {
        if (this.onClick != null){
            this.onClick();
        }
    }
    
}
UI.registerComponent("CanvasButton", {
    create = function(o) {
        return CanvasButton(o)
    }
});