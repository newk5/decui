elements <- [
    GUIButton, GUICanvas , GUICheckbox , GUIEditbox, GUILabel, GUIListbox ,
    GUIMemobox ,GUIProgressBar ,GUIScrollbar, GUISprite, GUIWindow
    ];

    function attachProps(props) {
        foreach(p,prop in props ) {
            foreach(i,e in elements ) {
                e[prop] <- null;
            }
        }
    }

attachProps([ "UI","wrapOptions", "bindTo", "file","remove","autoResize", "RelativeSize", "ignoreGameResizeAutoAdjust"
    "id", "presets", "presetsList" "onClick", "onFocus", "onBlur", "onHoverOver","fadeOutTimer", "wrap", "delayWrap"
    "onHoverOut", "onRelease", "onDrag", "onCheckboxToggle", "onWindowClose", "align", "fadeInTimer", "fadeHigh"
    "onInputReturn", "onOptionSelect", "onScroll", "onWindowResize", "flags", "fadeStep", "fadeLow", "elementData"
    "onGameResize", "addPreset", "removePreset", "add", "parents"," children", "hidden", "context", "childLists","border"
    "contextMenu", "move", "parentSize", "tooltip", "tooltipVisible", "options",  "postConstruct", "preDestroy", "data", "metadata"
    "onPresetAdded", "onPresetRemoved"
       ]);

//attach new functions
foreach(i,e in elements ) {

     //removeBorders()
    e.rawnewmember("removeBorders", function() {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
           ui.removeBorders(this);
        }

    }, null, false);

      //updateBorders()
    e.rawnewmember("updateBorders", function() {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
           ui.updateBorders(this);
        }

    }, null, false);


    //addLeftBorder(borderObj)
    e.rawnewmember("addBorders", function(b= {}) {

       this.addLeftBorder(b);
       this.addRightBorder(b);
       this.addTopBorder(b);
       this.addBottomBorder(b);

    }, null, false);

      //isBorder()
    e.rawnewmember("isBorder", function() {

        return this.rawin("data") && this.data.rawin("isBorder") && this.data.isBorder;

    }, null, false);

    //addLeftBorder(borderObj)
    e.rawnewmember("addLeftBorder", function(b= {}) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
           ui.addBorder(this, b, "top_left");
        }

    }, null, false);

    //setBorderColor(border,colour)
    e.rawnewmember("setBorderColor", function(border, colour) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
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
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
            if (this.rawin("data") && this.data != null){
                if (this.data.rawin("borderIDs") && this.data.borderIDs != null){
                    foreach (idx, borderPos in this.data.borderIDs) {
                        local b = ui.Canvas(borderPos);
                        if (b != null && b.data.borderPos == border){
                            if (border=="left" || border == "right"){
                                b.Size.X = size;
                            }else{
                                b.Size.Y = size;
                            }
                            break;
                        }
                    }
                }
            }
        }

    }, null, false);

     //addRightBorder(borderObj)
    e.rawnewmember("addRightBorder", function(b= {}) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton" ){

           ui.addBorder(this, b, "top_right");
        }

    }, null, false);

     //addTopBorder(borderObj)
    e.rawnewmember("addTopBorder", function(b= {}) {
        local t = typeof this;
        local ui = this.UI;
        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
           ui.addBorder(this, b, "top_center");
        }

    }, null, false);

      //resetMoves()
    e.rawnewmember("resetMoves", function(b= {}) {
       if (this.metadata.rawin("movedPos")){
           this.metadata.movedPos.clear();
       }

    }, null, false);

     //addBottomBorder(borderObj)
    e.rawnewmember("addBottomBorder", function(b= {}) {
        local t = typeof this;
        local ui = this.UI;

        if (t == "GUICanvas" || t == "GUISprite" || t == "GUIButton"){
           ui.addBorder(this, b, "bottom_left");
        }

    }, null, false);

      //resize()
    e.rawnewmember("resize", function() {
        local t = typeof this;
        local ui = this.UI;

        if (t == "GUICanvas" || t == "GUIWindow"){

                 local maxY = 0;
                local maxX = 0;
                foreach (i, c in this.getChildren()) {
                    if (!c.rawin("className")) {
                        if (this.autoResize && !c.isBorder()){
                            local x = c.Position.X + c.Size.X;
                            local y = c.Position.Y + c.Size.Y;

                            if (maxX < x){
                                maxX = x;
                            }
                            if (maxY < y){
                                maxY = y;
                            }

                            if (this.Size.Y < maxY){
                                this.Size.Y = maxY;
                            }
                            if (this.Size.X < maxX){
                                this.Size.X = maxX;
                            }

                        }

                        c.realign();
                        c.resetMoves();
                        c.shiftPos();
                    }
                }

            if (this.autoResize){
                this.realign();
                this.resetMoves();
                this.shiftPos();
            }

        }

    }, null, false);

    //destroy()
    e.rawnewmember("destroy", function() {
        if (typeof this != "instance"){
            if (this.rawin("preDestroy") && this.preDestroy != null){
                this.preDestroy();
            }
            if (this.rawin("bindTo") && this.bindTo != null){
                ::UI.store.remove(this.bindTo, this.id);
            }

            if (this.isWrapped()){
                foreach (line in this.metadata.lines) {
                    UI.Label(line).destroy();
                }
                this.metadata.lines.clear();
            }
        }
        this.UI.Delete(this);
    }, null, false);


      //showTooltip()
    e.rawnewmember("showTooltip", function() {

        this.UI.showTooltip(this);
    }, null, false);
     //focus()
      e.rawnewmember("focus", function() {
        this.UI.Focus(this);
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
    e.rawnewmember("fadeIn", function(callback = {}) {

        local e = this;
        local id = e.id;
        local alpha = e.metadata.rawin("oldAlpha") ? e.metadata.oldAlpha : e.Alpha;
        e.show(false);
        if (e.fadeStep == null){
            e.fadeStep = 15;
        }
        if (e.fadeHigh == null){
            e.fadeHigh = alpha;
        }


        this.fadeInTimer = Timer.Create(::getroottable(), function() {
            if (e.Alpha < e.fadeHigh){
                e.Alpha+=e.fadeStep;
            }else {
                Timer.Destroy(e.fadeInTimer);
                if (callback.rawin("onFinish")){
                    callback.onFinish();
                }
            }
        }, 1, 0);
    }, null, false);

      //fadeOut()
    e.rawnewmember("fadeOut", function(callback = {}) {
        local e = this;
        local id = e.id;
        e.metadata["oldAlpha"] <- e.Alpha;

        if (e.fadeStep == null){
            e.fadeStep = 15;
        }
        if (e.fadeLow == null){
            e.fadeLow = 0;
        }

        this.fadeOutTimer = Timer.Create(::getroottable(), function() {
            if (e.Alpha > e.fadeLow){
                e.Alpha-=e.fadeStep;
            }else {
                e.hide();
                Timer.Destroy(e.fadeOutTimer);
                if (callback.rawin("onFinish")){
                    callback.onFinish();
                }
            }
        }, 1,0);
    }, null, false);

    //hide()
     e.rawnewmember("hide", function() {
         if (this.Position != null && (this.hidden == null || this.hidden == false) ){

             this.hidden = true;
             this.RemoveFlags(GUI_FLAG_VISIBLE);
             if (this.isWrapped()){
                foreach (line in this.metadata.lines) {
                    UI.Label(line).hide();
                }

            }
         }
    }, null, false);

    //show()
     e.rawnewmember("show", function(restoreAlpha = true) {

        this.hidden = false;

        this.AddFlags(GUI_FLAG_VISIBLE);
        if (this.Alpha == 0  && restoreAlpha){
            local alpha = this.metadata.rawin("oldAlpha") ? this.metadata.oldAlpha : 255;
            this.Alpha = alpha;
        }
        if (this.isWrapped()){
            foreach (line in this.metadata.lines) {
                UI.Label(line).show();
            }

        }

    }, null, false);

    //realign()
     e.rawnewmember("realign", function() {
        this.UI.align(this);
         if (this.isWrapped()){
            foreach (line in this.metadata.lines) {
                 this.UI.align(UI.Label(line));
            }

        }
    }, null, false);



    //click()
     e.rawnewmember("click", function() {
        if (this.onClick != null){
            this.onClick();
        }
    }, null, false);

     //getFirstParent()
     e.rawnewmember("getFirstParent", function() {
       if (this.parents.len() >0){
           return this.parents[this.parents.len()-1];
       }
       return null;
    }, null, false);

      //getLastParent()
     e.rawnewmember("getLastParent", function() {
       if (this.parents.len() >0){
           return this.parents[0];
       }
       return null;
    }, null, false);

    //addPreset(preset)
     e.rawnewmember("addPreset", function(p) {
        this.presets.push(p);
        local preset = UI.getPreset(p);
        UI.applyPreset(this,preset);
        if (this.rawin("onPresetAdded") && this.onPresetAdded != null){
            this.onPresetAdded(p);
        }
    }, null, false);

        //ignoresAutoAdjust
        e.rawnewmember("ignoresAutoAdjust", function() {
            if(this.rawin(ignoreGameResizeAutoAdjust)){
                if (this.ignoreGameResizeAutoAdjust == null || this.ignoreGameResizeAutoAdjust == false){
                    return false;
                }
                return this.ignoreGameResizeAutoAdjust;
            }else{
                return false;
            }
       })

        //resetPosition()
       e.rawnewmember("resetPosition", function() {
           if (this.metadata.ORIGINAL_POS != null){
               this.Position.X = this.metadata.ORIGINAL_POS.X;
               this.Position.Y = this.metadata.ORIGINAL_POS.X;
           }
       })

       //getWrapper()
       e.rawnewmember("getWrapper", function() {
            local wrapper = null;
            if (this.parents.len() == 0){
                wrapper = ::GUI.GetScreenSize();
            }else{
                local lastID = this.parents[this.parents.len()-1];

                local parent = ::UI.findById(lastID);
                wrapper =  parent == null ? ::GUI.GetScreenSize() : parent.Size;
            }
            return wrapper;
       })

        //getParent
        e.rawnewmember("getParent", function() {
            if (this.parents.len() == 0){
               return null;
            }else{
                local lastID = this.parents[this.parents.len()-1];

                local parent = ::UI.findById(lastID);
               return parent;
            }

       })

         //hasWrapOptions()
       e.rawnewmember("hasWrapOptions", function() {
            return this.rawin("wrapOptions") && this.wrapOptions != null;
       })

        //setText()
       e.rawnewmember("setText", function(t) {
            this.set("Text",t);
       })


         //isWrapped()
       e.rawnewmember("isWrapped", function() {
           return (this.rawin("metadata") && this.metadata != null && this.metadata.rawin("lines") && this.metadata.lines != null &&  this.metadata.lines.len()> 0 && (this.hasWrap() )  );
       })

         //set(fieldName, value)
       e.rawnewmember("set", function(fieldName, value, ignoreWrap = false) {
            local firstText = this.Text;
            this[fieldName] = value;
            if (fieldName == "Text" || fieldName == "FontSize"){
                this.Size.X = this.TextSize.X+10;
                this.Size.Y = this.TextSize.Y+4;
            }

             if (this.metadata.originalObject.rawin(fieldName)){
                    this.metadata.originalObject[fieldName] = value;
                }else {
                    this.metadata.originalObject[fieldName] <- value;
            }


            // ignoring wrap when inside `wrapText` to avoid heavy recursion followed by stack overflow
           if (!ignoreWrap && (this.isWrapped() || this.hasWrap())){

                if (fieldName == "Text" || fieldName == "FontSize" || fieldName == "FontName"){
                    local text = firstText;
                    foreach (line in this.metadata.lines) {
                        local l = UI.Label(line);
                        text += l.Text;
                        l.destroy();

                    }

                    if (fieldName == "FontSize" || fieldName == "FontName"){
                       this.Text = text;
                    }
                    this.metadata.lines.clear();
                    if(parents.len() > 0) {
                        local parentID = this.parents[this.parents.len()-1];
                        if (parentID != null){
                            local parent = UI.Canvas(parentID);
                            if (parent == null) {
                                parent = UI.Sprite(parentID);
                            }
                            if (parent == null){
                                parent = UI.Window(parentID);
                            }

                            this.wrapText(parent, this, parent.Size.X-10)
                        }
                    }
                }else{
                     foreach (line in this.metadata.lines) {
                        try {
                            UI.Label(line)[fieldName] = value;
                        } catch(e){}

                    }
                }



           }
       });

       //hasWrap()
       e.rawnewmember("hasWrap", function() {
            return this.rawin("wrap") && this.wrap != null && this.wrap == true;
       });

       //enable()
       e.rawnewmember("enable", function() {
          this.RemoveFlags(GUI_FLAG_DISABLED);
       });

     //disable()
       e.rawnewmember("disable", function() {
          this.AddFlags(GUI_FLAG_DISABLED);
       });

       //forceWrap()
       e.rawnewmember("forceWrap", function() {
             local lastID = this.parents[this.parents.len()-1];

            if (lastID != null){
                local parent = ::UI.findById(lastID);
                this.wrapText(parent, this, parent.Size.X-10)
            }
       });


      //wrapText(parent, firstLabel, size)
       e.rawnewmember("wrapText",function (parent, firstlabel,  size){

        local width = size;
        local wordWrap = false;
        if (this.hasWrapOptions()){
            if (this.wrapOptions.rawin("maxWidth")){
                width = this.wrapOptions.maxWidth;
            }

            if (this.wrapOptions.rawin("wordWrap")){
                wordWrap = this.wrapOptions.wordWrap;
            }
        }
        local rem = [];
        local resized = false;

        while (this.Position.X + this.TextSize.X > width){
            if(!wordWrap) {
                local lastLetter =  this.Text.slice( this.Text.len()-1, this.Text.len());
                local remaining = this.Text.slice(0,this.Text.len()-1)
                this.set("Text", remaining, true);

                rem.push(lastLetter);
                resized = true;
            }
            else {
                local words = split(this.Text, " ");
                local lastWord = words[words.len()-1] + " ";
                local remaining = "";

                for(local i = 0; i < words.len() - 1; ++i) {
                    remaining += words[i] + " ";
                }

                this.set("Text", remaining, true);
                rem.push(lastWord);
                resized = true;
            }
        }

        if (resized){

            rem.reverse();
            local obj = this.metadata.originalObject;
            obj.id = obj.id+"::line"+ (firstlabel.metadata.lines.len()+1);
            obj.Text = rem.reduce(@(p, c) p + c);
            if (!obj.rawin("move")){
                obj["move"] <- {};
            }else{
                obj.move = {};
            }

            local line = UI.Label(obj);

            line.set("Text", obj.Text, true);
            local lineSpacing = 0;
            if (firstlabel.hasWrapOptions()){
                if (firstlabel.wrapOptions.rawin("lineSpacing")){
                    lineSpacing = firstlabel.wrapOptions.lineSpacing;
                }
            }

            line.Position.Y = this.Position.Y;
            line.Position.Y += this.TextSize.Y+5 + lineSpacing;
            firstlabel.metadata.lines.push(line.id);
            line.wrapText(parent,firstlabel,size);
            parent.add(line, false);
        }
        return resized;
    });
 
      //applyRelativeSize()
       e.rawnewmember("applyRelativeSize", function() {
           ::UI.applyRelativeSize(this);
       });


      //getMaxPosition()
    e.rawnewmember("getMaxPosition", function() {
       return VectorScreen(this.Position.X+this.getRealSize().X, this.Position.Y+this.getRealSize().Y)
    });

    //getRealSize() (when the element is a GUILabel return .TextSize instead of .Size )
    e.rawnewmember("getRealSize", function() {
        if (typeof this == "GUILabel"){
            return this.TextSize;
        }
       return this.Size;
    });


     //attachChild(p)
     e.rawnewmember("attachChild", function(childElement, repos = true) {
        local t = typeof this;
        local ct = typeof childElement; 
        
    
         if (this.id != null && childElement.id != this.id ) {
   
            local list =  this.UI.mergeArray(this.parents, this.id);
            if (this.childLists.find(childElement.metadata.list) == null) {
                this.childLists.push(childElement.metadata.list);
            }
            if (childElement.metadata == null){
                childElement.metadata <- { parentPos = this.Position };
            }else{
                childElement.metadata["parentPos"] <- this.Position;
            }
            childElement.metadata["parentID"] <- this.id;
           
            childElement.parents = list;
            if (ct == "instance"){ //attach the parents list to the instance canvas aswell
                childElement.getCanvas().parents = list;
            }
           
    
            this.AddChild(ct =="instance" ? childElement.getCanvas(): childElement);
            if (childElement.rawin("RelativeSize") && childElement.RelativeSize != null) {
                 ::UI.applyRelativeSize(childElement);
            }
            if (childElement.rawin("align") && childElement.align != null &&  (!childElement.rawin("isBorder") ||  !childElement.isBorder() )) {
                childElement.realign();
            }
            
    
            if ( this.autoResize  &&  !childElement.hasWrap() &&  (!childElement.rawin("isBorder") || !childElement.isBorder() ) ){
                local adjusted = false;
                local Max = childElement.getMaxPosition();
                local xPadding = 11;
                if ( Max.X > this.Size.X){
                    this.Size.X = Max.X +xPadding; 
                    adjusted = true;
                }
                if ( Max.Y > this.Size.Y){
                    this.Size.Y = Max.Y;
                    adjusted = true;
                }
               if (adjusted){
                    this.rePosition();
    
                     foreach (i, c in this.getChildren()) {
                       
                        c.rePosition();
                    }
                }

                this.metadata["wasResized"] <- adjusted;
     
            }else{
                this.metadata["wasResized"] <- false;
            }
            
    
            if (childElement.rawin("shiftPos") && childElement.shiftPos != null && childElement.rawin("move") && childElement.move != null){
                childElement.resetMoves();
                childElement.shiftPos();
               
            }
            
            if (childElement.rawin("hasWrap") && childElement.hasWrap() && !childElement.delayWrap){
                childElement.wrapText(this,childElement,this.Size.X-10)
            }
            if (repos){
                childElement.rePosition();
            }
            

            childElement.getMaxPosition();
    
        }
    }, null, false);


    //add(e)
     e.rawnewmember("add", function(child, repos = true) {
           this.attachChild(child, repos);
    }, null, false);


    //rePosition()   
    e.rawnewmember("rePosition", function() {
        local hasMove = this.rawin("move") && this.move != null;
        local hasAlign =  this.rawin("align") && this.align != null;
        if (hasAlign || hasMove){
            this.resetPosition();
            this.realign();
            this.resetMoves();
            this.shiftPos();
        }
       
    }, null, false);     

     //shift()
     e.rawnewmember("shiftPos", function() {
       this.UI.shift(this);
        if (this.isWrapped()){
            foreach (line in this.metadata.lines) {
                 this.UI.shift(UI.Label(line));
           }

        }
    }, null, false);

     //getNestedIndexes()
    e.rawnewmember("getNestedIndexes", function() {

        local list = this.getChildrenIndexes();
        local map = {};

        foreach (e in list) {
            if (map.rawin(e.list)){
                map[e.list].push(e.index);
            }else{
                map[e.list] <- [e.index];
            }
        }

        //sort all arrays from highest to lowest to avoid them being re-indexed later when the items are being removed
        foreach (list,indexes in map ) {
            indexes.sort();
            indexes.reverse();
        }
        return map;

    }, null, false);


     //getChildrenIndexes()
    e.rawnewmember("getChildrenIndexes", function() {
        local arr = [];
        local children = this.getChildren();

        foreach (c in children){
            arr.push({list=c.metadata.list, index = c.getIndex(), id = c.id});
            local subChildren = c.getChildrenIndexes();
            if (subChildren.len()>0){
                foreach (sc in subChildren) {
                  arr.push(sc);
                }
            }
        }

        return arr;
    }, null, false);



    //getIndex()
    e.rawnewmember("getIndex", function() {
        return this.metadata.index;
    }, null, false);

    //removeChildren()
     e.rawnewmember("removeChildren", function(recursiveCall = false, toBeRemoved = null) {
        if (this.rawin("preDestroy") && this.preDestroy != null){
            try {
                this.preDestroy();
            }
            catch(e) {
                Console.Print(this.id)
                Console.Print(e);
            }
        }

        if(toBeRemoved == null) {
            toBeRemoved = {};
        }

        this.UI.removeChildren(this, toBeRemoved);

        if(!recursiveCall) {
            foreach(listIdx, indicesArray in toBeRemoved) {
                indicesArray.sort();
                indicesArray.reverse();
                foreach(idx in indicesArray) {
                    UI.lists[listIdx].remove(idx);
                }
            }
        }
    }, null, false);


    //getChildren()
     e.rawnewmember("getChildren", function() {
        return this.UI.getChildren(this);
    }, null, false);

    //removePreset(preset)
     e.rawnewmember("removePreset", function(name) {
        local idx = this.presets.find(name);
        if (idx != null){
            this.presets.remove(idx);
            
        if (this.rawin("onPresetRemoved") && this.onPresetRemoved != null){
            this.onPresetRemoved(name);
        }
        }
       
       
    }, null, false);

     //applyPresets()
     e.rawnewmember("applyPresets", function() {
        foreach (i, p in this.presetsList) {
            this =  this.UI.applyElementProps(this,p);
        }
    }, null, false);

     //hasParents()
     e.rawnewmember("hasParents", function() {
       return this.parents.len() > 0;
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