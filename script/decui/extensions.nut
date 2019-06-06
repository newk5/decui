elements <- [
    GUIButton, GUICanvas , GUICheckbox , GUIEditbox, GUILabel, GUIListbox ,
    GUIMemobox ,GUIProgressBar ,GUIScrollbar, GUISprite, GUIWindow
    ];

    function attachProps(props) {
        foreach(p,prop in props ) { 
            foreach(i,e in elements ) { 
                if (prop == "data") {
                     e[prop] <- { };
                } else if (prop == "parents" || prop == "childLists") {
                     e[prop] <- [];
                } else {
                    e[prop] <- null;
                }
            }
        }
    }
 
attachProps([ "UI", "file","remove",
    "id", "presets", "presetsList" "onClick", "onFocus", "onBlur", "onHoverOver","shift","fadeOutTimer"
    "onHoverOut", "onRelease", "onDrag", "onCheckboxToggle", "onWindowClose", "align", "fadeInTimer", "fadeHigh"
    "onInputReturn", "onOptionSelect", "onScroll", "onWindowResize","lastPos", "flags", "fadeStep", "fadeLow",
    "onGameResize", "addPreset", "removePreset", "addChild", "parents"," children", "hidden", "context", "childLists",
    "contextMenu", "move", "parentSize", "tooltip", "tooltipVisible", "options", "postConstruct", "data", "metadata"
       ]);

//attach new functions
foreach(i,e in elements ) { 
     
     //removeBorders()
    e.rawnewmember("removeBorders", function() {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
           ui.removeBorders(this);
        }
       
    }, null, false);

      //updateBorders()
    e.rawnewmember("updateBorders", function() {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
           ui.updateBorders(this);
        }
       
    }, null, false);


    //addLeftBorder(borderObj)
    e.rawnewmember("addBorders", function(b) {

        this.addLeftBorder(b);
        this.addRightBorder(b);
        this.addTopBorder(b);
        this.addBottomBorder(b);
       
    }, null, false);

    //addLeftBorder(borderObj)
    e.rawnewmember("addLeftBorder", function(b) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
           ui.addBorder(this, b, "top_left");
        }
       
    }, null, false);

    //setBorderColor(border,colour)
    e.rawnewmember("setBorderColor", function(border, colour) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
            if (this.rawin("data") && this.data != null){
                
                if (this.data.rawin("borderIDs") && this.data.borderIDs != null){ 
                    foreach (idx, borderPos in this.data.borderIDs) {
                       
                        local b = ui.Canvas(borderPos);
                        if (b != null && b.data.borderPos == border){
                            b.Colour = colour;  
                            break;
                        }
                    }
                }
            }
        }
       
    }, null, false);

     //setBorderSize(border,size)
    e.rawnewmember("setBorderSize", function(border, size) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
            if (this.rawin("data") && this.data != null){
                if (this.data.rawin("borderIDs") && this.data.borderIDs != null){
                    foreach (idx, borderPos in this.data.borderIDs) {
                        local b = ui.Canvas(borderPos);
                        if (b != null && b.data.borderPos == border){
                            b.size = size;
                            break;
                        }
                    }
                }
            }
        }
        
    }, null, false);

     //addRightBorder(borderObj)
    e.rawnewmember("addRightBorder", function(b) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
           ui.addBorder(this, b, "top_right");
        }
       
    }, null, false);

     //addTopBorder(borderObj)
    e.rawnewmember("addTopBorder", function(b) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas"){
           ui.addBorder(this, b, "top_center");
        }
       
    }, null, false);

     //addBottomBorder(borderObj)
    e.rawnewmember("addBottomBorder", function(b) {
        local t = typeof this;
        local ui = this.UI;
      
        if (t == "GUICanvas"){
           ui.addBorder(this, b, "bottom_left");
        }
       
    }, null, false);

    //destroy()
    e.rawnewmember("destroy", function() {
        this.UI.Delete(this);
    }, null, false);

     //remove()
    e.rawnewmember("remove", function() {
        this.UI.Delete(this);
    }, null, false);

      //showTooltip()
    e.rawnewmember("showTooltip", function() {
     
        this.UI.showTooltip(this);
    }, null, false);

    //clearTooltip()
     e.rawnewmember("clearTooltip", function() {
        if (this.rawin("tooltip") && this.tooltip != null){
            if (this.tooltipVisible != null && this.tooltipVisible  ){
                this.UI.DeleteByID(this.id+"::tooltip");
                this.tooltipVisible = false;
            }
        }
       
    }, null, false);

    //fadeIn()
    e.rawnewmember("fadeIn", function() {
    
        local e = this; 
        local id = e.id;
        e.show();
        if (e.fadeHigh == null){
            e.fadeHigh = 255;
        }
       
        
        this.fadeInTimer = Timer.Create(::getroottable(), function(text) {
            if (e.Alpha < e.fadeHigh){ 
                e.Alpha+=e.fadeStep;
            }else {
                Timer.Destroy(e.fadeInTimer);
            }
        }, 1, 0, id+"fadeInTimer"+Script.GetTicks());
    }, null, false);

      //fadeOut() 
    e.rawnewmember("fadeOut", function() { 
        local e = this;  
        local id = e.id; 

        if (e.fadeStep == null){
            e.fadeStep = 15;
        }
        if (e.fadeLow == null){
            e.fadeLow = 0;
        }
      
        this.fadeOutTimer = Timer.Create(::getroottable(), function(text) {
            if (e.Alpha > e.fadeLow){
                e.Alpha-=e.fadeStep;
            }else {
                e.hide();
                Timer.Destroy(e.fadeOutTimer);
            }
        }, 1,0, id+"fadeOutTimer"+Script.GetTicks());
    }, null, false);

    //hide()
     e.rawnewmember("hide", function() {
         if (this.Position != null && (this.hidden == null || this.hidden == false) ){
             this.lastPos = VectorScreen(this.Position.X, this.Position.Y);
             this.Position = VectorScreen(-999999,-999999);
             this.hidden = true;
             //this.Alpha = 0;
         }
    }, null, false);

    //show()
     e.rawnewmember("show", function() {
         if (this.lastPos != null){
            this.hidden = false;
            this.Position = VectorScreen(this.lastPos);
            this.lastPos = null; 
            // this.Alpha = 255;
         }
    }, null, false);

    //realign()
     e.rawnewmember("realign", function() {
        this.UI.align(this);
    }, null, false);

 
    //click()
     e.rawnewmember("click", function() {
        if (this.onClick != null){
            this.onClick();
        }
    }, null, false);

    //addPreset(preset)
     e.rawnewmember("addPreset", function(p) {
        if (!p.rawin("id") ||  p.id == null  && p.rawin("name") ){

            if (this.presetsList == null){
                this.presetsList = [];
                this.presets =[];
            }

            if (this.presets.find(p.name) == null) {
                this.presetsList.push(p);
                this.presets.push(p.name);
                this =  this.UI.applyElementProps(this,p);
            }
        }
    }, null, false); 

    //add(e)
     e.rawnewmember("addChild", function(p) {
        
        p.parentSize = this.Size;
        if ( p.rawin("className")){ 
            
            if (p.className == "InputGroup"){
                p.attachParent(this,0);
            } else if (p.className == "GroupRow"){   
               p.parentID = this.id;
               p.calculatePositions();
            } 
        }else{ 
            if (this.id != null && p.id != this.id ) {
                local list =  this.UI.mergeArray(this.parents, this.id);
                if (this.childLists.find(p.metadata.list) == null) {
                    this.childLists.push(p.metadata.list);
                }

                p.parents = list;
                this.AddChild(p);
            }
        }
        
    }, null, false);

  
     //shift()
     e.rawnewmember("shiftPos", function() {
       this.UI.shift(this);
    }, null, false);

    //removeChildren()
     e.rawnewmember("removeChildren", function() {
        this.UI.removeChildren(this);
    }, null, false);


    //getChildren()
     e.rawnewmember("getChildren", function() {
        return this.UI.getChildren(this);
    }, null, false);

    //removePreset(preset)
     e.rawnewmember("removePreset", function(name) {
        if (id!=null){
            if (presets !=null) {
                local idx = this.presets.find(name);
                if (idx != null){
                    this.presets.remove(idx);
                }
                if  (this.presetsList != null) {
                     local index = null;

                    foreach (i, p in this.presetsList) {
                        if (p.name ==name){
                            index = i;
                            break;
                        }
                    }
                    
                    if (index != null) {
                        this.presetsList.remove(index);
                        this.applyPresets();
                    }
                }
            }
        }
    }, null, false);

     //applyPresets()
     e.rawnewmember("applyPresets", function() {
        foreach (i, p in this.presetsList) {
            this =  this.UI.applyElementProps(this,p);
        }
    }, null, false);
    //hasPreset(name)
     e.rawnewmember("hasPreset", function(name) {
       if (this.presets ==  null) {
           return false;
       }else{
           return (this.presets.find(name) != null);
       }
    }, null, false);
}