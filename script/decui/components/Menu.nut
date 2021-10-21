class OptionsMenu extends DecUIComponent {

    className="Menu";

    Size = null;
    RelativeSize = null;
    options = null;

    padding = null;

    layout = null;
    optionsSize = null;

    optionsStyle =null;

    optionsColour = null;
    labelColour = null;

    onHoverOverStyle= null;

    hoverColour = null;
    hoverLabelColour = null;

    borderStyle = null;
    labelStyle = null;
    backgroundColour = null;
    alwaysKeepBorders = null;
    labelProps = ["TextColour", "FontSize", "align"];

    onHoverOver = null
    onHoverOut = null;
    onClick = null;
    lastClickedOption= null;
    multipleSelections = null;
    selectedOptions = null;

    constructor(o) {
        base.constructor(o);

        //init defaults
        local rs = null;

         if (o.rawin("layout")){
            this.layout = o.layout;
        } else{
              this.layout ="vertical";
        }

        this.optionsStyle = {
            RelativeSize = this.layout == "vertical" ? ["100%", "7%"] : ["20%", "15%"]
            Size = null
            Colour = Colour (100,100,100,100)
            onHover = {
                Colour = Colour(60,60,60,255)
                border = {  size = 1 }
            }
            border = null
        };

        this.labelStyle = {
            TextColour = Colour(255,255,255)
            onHover = {
                TextColour = Colour(255,255,255)
            }
            FontSize = 18
            align ="center"
            move = {up =3}
        }


        this.RelativeSize =  this.layout == "vertical" ? ["25%","80%"] : ["100%","25%"] ;
        this.align = this.layout == "vertical" ? "bottom_left" : "center";
        this.options = [];
        this.move = {};
        this.padding = 0;
        this.backgroundColour = Colour (100,100,100,100)
        this.alwaysKeepBorders = false;
        this.multipleSelections = false;

        if (o.rawin("onClick")){

            this.onClick= o.onClick;
        }

        if (o.rawin("multipleSelections")){
            this.multipleSelections= o.multipleSelections;
        }
        this.selectedOptions = [];

        if (o.rawin("onHoverOver")){
            this.onHoverOver= o.onHoverOver;
        }
         if (o.rawin("onHoverOut")){
            this.onHoverOut= o.onHoverOut;
        }

        if (o.rawin("alwaysKeepBorders")){
           this.alwaysKeepBorders = o.alwaysKeepBorders;
        }

        if (o.rawin("optionsStyle")){
            local opt = o.optionsStyle;
            local props = ["RelativeSize","Size", "Colour", "onHover", "border"];
            foreach (prop in props) {
                if (!opt.rawin(prop)) {
                    opt[prop] <- this.optionsStyle[prop];
                }

            }
            this.optionsStyle = opt;
        }

        if (o.rawin("labelStyle")){
            local opt = o.labelStyle;
            local props = ["TextColour","onHover", "FontSize", "align", "move"];
            foreach (prop in props) {
                if (!opt.rawin(prop)) {
                    opt[prop] <- this.labelStyle[prop];
                }

            }
            this.labelStyle = opt;
        }

         if (o.rawin("backgroundColour")){
            this.backgroundColour = o.backgroundColour;
        }
        if (o.rawin("options")){
            this.options = o.options;
        }

        if (o.rawin("RelativeSize")){
            this.RelativeSize = o.RelativeSize;
        }

        if (o.rawin("padding")){
            this.padding = o.padding;
        }
        if (o.rawin("optionsSize")){
            this.optionsSize = o.optionsSize;
        }
        

        this.build();




    }

    function applyStyle(canvas, label, style, defaults= false) {
        if (style.rawin("Colour")){
            canvas.Colour = style.Colour;
        }

        if (defaults){

             foreach (prop in this.labelProps) {
                if (style.rawin(prop)) {
                     label[prop] =  style[prop];
                }else{

                    local val =this.labelStyle[prop];
                    label[prop] = val;


                }
            }
        } else if (style.rawin("label")){
            local lblStyle = style.label
            foreach (prop in this.labelProps) {
                if (lblStyle.rawin(prop)) {
                    label[prop] = lblStyle[prop];
                }else{
                    label[prop] =    this.labelStyle[prop];
                }
            }

        }
        if (style.rawin("border") && style.border != null){
            if (this.isFullBorder(style.border)){
                canvas.addBorders(style.border);
            }
            if (style.border.rawin("left")){
                canvas.addLeftBorder(style.border.left);
            }
            if (style.border.rawin("bottom")){
                canvas.addBottomBorder(style.border.bottom);
            }
            if (style.border.rawin("top")){
                canvas.addTopBorder(style.border.top);
            }
            if (style.border.rawin("right")){
                canvas.addRightBorder(style.border.right);
            }
        }
    }

    function isFullBorder(b) {
        return !b.rawin("top") && !b.rawin("bottom") && !b.rawin("left") && !b.rawin("right");
    }

    function applyHoverOver(canvas, label, option) {

        if (option.rawin("style") && option.style.rawin("onHover")){

            local style = option.style.onHover;
            this.applyStyle(canvas, label, style);

        } else {
            this.applyStyle(canvas, label, this.optionsStyle.onHover);
            this.applyStyle(canvas, label, this.labelStyle.onHover, true);
        }

    }

      function applyHoverOut(canvas, label, option) {
        if (option.rawin("clicked") && option.clicked){
            return;
        }
        if (option.rawin("style")){

               this.applyStyle(canvas, label, option.style, true);
        }else{
            this.applyStyle(canvas, label, this.optionsStyle);
            this.applyStyle(canvas, label, this.labelStyle, true);
        }
        label.realign();
        label.resetMoves();
        label.shiftPos();
        if (!this.alwaysKeepBorders){
            canvas.removeBorders();
        }

    }

    function getOptionStylePropOrDefault(prop,option){
        if (option.rawin("style") && option.style.rawin(prop)){
            return option.style[prop];
        }
        return this.optionsStyle[prop];
    }

    function getLabelStylePropOrDefault(prop,option){
        if (option.rawin("style") && option.style.rawin(prop)){
            return option.style[prop];
        }
        return this.labelStyle[prop];
    }

    function applyOnClick(canvas, label) {
        if (this.onClick != null){
            this.onClick(canvas,label);
        }
    }
    function removeClickedState(canvasID) {
        foreach (idx,o in this.options) {

            if (o.canvasID == canvasID){
                o.clicked = false;
                this.applyHoverOut(UI.Canvas(o.canvasID), UI.Label(o.labelID), o);
            }
        }
    }

    function getSelectedOption() {
        foreach (idx,o in this.options) {
            if (o.rawin("clicked") && o.clicked){
                return o.label;
            }
        }
        return "";
    }

     function getSelectedOptions() {
        local opts = [];
        foreach (idx,o in this.options) {
            if (o.rawin("clicked") && o.clicked){
                opts.push(o.label);
            }
        }
        return opts;
    }

    function deselectOption(option) {
        foreach (idx,o in this.options) {
            if (o.rawin("clicked") && o.clicked && option == o.label){
                 this.removeClickedState(o.canvasID);
            }
        }
    }

    function clearSelectedOptions() {
         foreach (idx,o in this.options) {
            if (o.rawin("clicked") && o.clicked){
                 this.removeClickedState(o.canvasID);
            }
        }
    }


    function build() {
        local wrapper = UI.Canvas({
            id = this.id
            context = this
            move = this.move
            presets = this.presets
            align = this.align
            RelativeSize = this.RelativeSize
            align =  this.align
            Colour = this.backgroundColour
        })
        local yPos = 0;
        local xPos = 0;


        foreach (idx,o in this.options) {
            local labelID = this.id+"::option"+idx+"::label";
            local canvasID =this.id+"::option"+idx;
            o["labelID"] <-labelID;
            o["canvasID"] <-canvasID ;

            local labelObj = { id = labelID};
            labelObj["id"] <- labelID;
            labelObj["Text"] <- o.label;
            labelObj["elementData"] <-  { index = idx, option = o, canvasID = canvasID }
            labelObj["context"] <- this;
            labelObj["onClick"] <- function(){
                if(!context.multipleSelections) {
                    context.removeClickedState(context.lastClickedOption);
                    context.lastClickedOption = this.elementData.canvasID;
                }else{
                    if (context.selectedOptions.find(this.elementData.canvasID) == null){
                        context.selectedOptions.push(this.elementData.canvasID);
                    }
                }

                local canvas =UI.Canvas(context.id+"::option"+this.elementData.index);
                context.applyOnClick(canvas,this);
                this.elementData.option["clicked"] <- true;
            };
            labelObj["move"] <- this.getLabelStylePropOrDefault("move",o);
            labelObj["FontSize"] <- this.getLabelStylePropOrDefault("FontSize",o);
            labelObj["align"] <- this.getLabelStylePropOrDefault("align",o);
            labelObj["TextColour"] <- this.getLabelStylePropOrDefault("TextColour",o);
            labelObj["onHoverOver"] <- function(){
                local canvas =UI.Canvas(context.id+"::option"+this.elementData.index);
                context.applyHoverOver(canvas, this,this.elementData.option);
                if (context.onHoverOver != null){
                    context.onHoverOver(canvas,this);
                }
            };
            labelObj["onHoverOut"] <- function(){
                local canvas =UI.Canvas(context.id+"::option"+this.elementData.index);
                context.applyHoverOut(canvas, this,this.elementData.option);
                 if (context.onHoverOut != null){
                    context.onHoverOut(canvas,this);
                }
            };

            local label = UI.Label(labelObj);
            label.RemoveFlags(GUI_FLAG_INHERIT_ALPHA);

            local optCanvas = UI.Canvas({
                id = this.id+"::option"+idx
                context =this
                onClick = function () {
                    if(!context.multipleSelections) {
                        context.removeClickedState(context.lastClickedOption);
                        context.lastClickedOption = this.id;
                    }else{
                        if (context.selectedOptions.find(this.id) == null){
                            context.selectedOptions.push(this.id);
                        }
                    }
                    context.applyOnClick(this, label);
                    this.elementData.option["clicked"] <- true;
                }
                elementData = { index = idx, labelID = labelID, option = o }
                RelativeSize = this.getOptionStylePropOrDefault("RelativeSize",o)
                Size = this.getOptionStylePropOrDefault("Size",o)
                Colour = this.getOptionStylePropOrDefault("Colour",o)
                border = this.getOptionStylePropOrDefault("border",o)
                Position = VectorScreen(xPos, yPos)
                onHoverOver = function () {
                    context.applyHoverOver(this, label,this.elementData.option);
                      if (context.onHoverOver != null){
                        context.onHoverOver(this,label);
                    }
                }
                onHoverOut = function () {
                    context.applyHoverOut(this, label,this.elementData.option);
                     if (context.onHoverOut != null){
                        context.onHoverOut(this,label);
                    }
                }
            })
            optCanvas.add(label);
            wrapper.add(optCanvas);
            if (this.layout == "vertical"){
                yPos +=optCanvas.Size.Y+this.padding;
            }else{
                xPos +=optCanvas.Size.X+this.padding;
            }
        }
        
        
        this.Size = VectorScreen(wrapper.Size.X, wrapper.Size.Y);
    }

}

UI.registerComponent("Menu", {
    create = function(o) {
        local c = OptionsMenu(o);
        return c;

    }
});
