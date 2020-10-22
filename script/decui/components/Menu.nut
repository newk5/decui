class OptionsMenu extends Component {
    
    
    id = null;
    Size = null;
    RelativeSize = null;
    options = null;
    align =null;
    move= null;
    padding = null;
    
    layout = null;
    optionsSize = null;
    optionsColour = null;
    labelColour = null;

    hoverColour = null;
    hoverLabelColour = null;

    borderStyle = null;
    labelStyle = null;

    constructor(o) {
        this.id = o.id;
        //init defaults
        this.layout ="vertical";
        this.RelativeSize =["25%","80%"];
        this.align = "bottom_left";
        this.options = [];
        this.move = {};
        this.padding = 0;
        this.optionsSize = ["100%", "7%"];
        
        this.optionsColour = Colour (100,100,100,100); 
        this.labelColour = Colour(255,255,255);
        this.hoverColour = Colour(60,60,60,255);
        this.hoverLabelColour = Colour(255,255,255);
        this.borderStyle = {};
        this.labelStyle = {
            FontSize = 18
            TextColour = this.labelColour
            align ="center"
            move = {up =3}
        };

       

        base.constructor(o.id);

        this.build();
        
    }

    function applyHoverOver(canvas, label, option) {
        
    }

    function applyHoverOut(canvas, label, option) {
        
    }


    function build() {
        
    }

}