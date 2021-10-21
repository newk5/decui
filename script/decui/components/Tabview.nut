class Tabview  extends DecUIComponent {

    tabs = null;
    className = "TabView";
    style = null;
    Size = null;
    onTabChangeEvent = null;
    tabsHeight = null;
    x = null;
    y = null;
    currentTabIdx = null;
    lastHeight = null;
    lastWidth = null;
    maxContentSize = null;
    initialSize =null;
    activeContentCanvasID = null;
    wasResizedDuringBuild = null;


    constructor(o) {
         base.constructor(o);

        this.tabs = [];
        this.x = 0;
        this.currentTabIdx = -1;
        this.maxContentSize =  VectorScreen(0,0);

        this.style = { };
        local defaultStyle = {
            titleColor = Colour(51,150,255),
            titleSize = 17,
            tabColor = Colour(51,57,61,200),
            onHoverTabColor =  Colour(70,70,70),
            activeTabColor =  Colour(70,70,70),
            background = Colour(0,0,0,150),
            borderColor = Colour(255,255,255),
            borderSize = 2,
            headerBorderColor = Colour(255,255,255),
            headerBorderSize = 2
            headerInactiveBorderColor = Colour(255,255,255)
        };


        if (o.rawin("tabs")){
            this.tabs = o.tabs;
        }
        if (o.rawin("onTabClicked")){
            this.onTabChangeEvent = o.onTabClicked;
        }
        if (o.rawin("Size")){
            this.Size = o.Size;
            this.initialSize = o.Size.X;
        }


         if (o.rawin("style")){

             this.style = o.style;
             if (style.rawin("titleSize")) {
                this.style.titleSize = o.style.titleSize;
            }else {
               this.style.titleSize <- defaultStyle.titleSize;
            }
            if (style.rawin("titleColor")){
                this.style.titleColor = o.style.titleColor;
            } else{
                this.style.titleColor <- defaultStyle.titleColor;
            }
            if (style.rawin("tabColor")) {
                this.style.tabColor = o.style.tabColor;
            }else{
                this.style.tabColor <- defaultStyle.tabColor;
            }
            if (style.rawin("onHoverTabColor")) {
                this.style.onHoverTabColor = o.style.onHoverTabColor;
            }else{
                this.style.onHoverTabColor <- defaultStyle.onHoverTabColor;
            }
             if (style.rawin("activeTabColor")) {
                this.style.activeTabColor = o.style.activeTabColor;
            }else{
                this.style.activeTabColor <- defaultStyle.activeTabColor;
            }
             if (style.rawin("background")) {
                this.style.background = o.style.background;
            }else{
                this.style.background <- defaultStyle.background;
            }
              if (style.rawin("borderColor")) {
                this.style.borderColor = o.style.borderColor;
            } else{
                this.style.borderColor <- defaultStyle.borderColor;
            }
             if (style.rawin("borderSize")) {
                this.style.borderSize = o.style.borderSize;
            }else{
                this.style.borderSize <- defaultStyle.borderSize;
            }
             if (style.rawin("headerBorderColor")) {
                this.style.headerBorderColor = o.style.headerBorderColor;
            } else{
                this.style.headerBorderColor <- defaultStyle.headerBorderColor;
            }
             if (style.rawin("headerBorderSize")) {
                this.style.headerBorderSize = o.style.headerBorderSize;
            } else{
                this.style.headerBorderSize <- defaultStyle.headerBorderSize;
            }

             if (style.rawin("headerInactiveBorderColor")) {
                this.style.headerInactiveBorderColor = o.style.headerInactiveBorderColor;
            } else{
                this.style.headerInactiveBorderColor <- defaultStyle.headerInactiveBorderColor;
            }

            //

        }else{
            this.style = defaultStyle;
        }




        foreach (idx, tab in this.tabs){
            if (tab.rawin("content") && tab.content !=null){
                foreach (i, child in tab.content){

                    if (child.rawin("align") && child.align != null ){
                        child.Position = VectorScreen(0,0);
                    }
                }
            }

        }

        this.build();

    }

    function getTabByDataID(id){
        for (local i = 0; i<this.tabs.len(); i++){
            if (this.tabs[i].data.id == id){
                return this.tabs[i];
            }
        }
    }

    function indexOfTab(t){
        foreach(idx,  tab in this.tabs){
            if (tab.title == t){
                return idx;
            }
        }
        return null;
    }


    function getTabHeaderStyle(tab){
        local color = null;
        local ac = null;
        local tc = null;

        if (tab.rawin("style") && tab.style != null && tab.style.rawin("tabColor") && tab.style.tabColor != null ){
               color =  tab.style.tabColor;
        } else{
            if (this.style.rawin("tabColor") && this.style.tabColor != null){
                color  =  this.style.tabColor;
            }

        }
        if (tab.rawin("style") && tab.style != null && tab.style.rawin("activeTabColor") && tab.style.activeTabColor != null ){
            ac =  tab.style.activeTabColor;
        } else{
              if (this.style.rawin("activeTabColor") && this.style.activeTabColor != null){
                ac  =  this.style.activeTabColor;
              }
        }
        if (tab.rawin("style") && tab.style != null && tab.style.rawin("titleColor") && tab.style.titleColor != null ){
            tc =  tab.style.titleColor;
        } else{
            if (this.style.rawin("titleColor") && this.style.titleColor != null){
                tc  =  this.style.titleColor;
            }
        }

        return {tabColor = color, activeTabColor = ac, titleColor = tc};
    }

    function changeTab(tabIdx){
        local tab = this.tabs[tabIdx];
        if (tab != null){
            local wrapper = UI.Canvas(this.id);
            this.clearActiveTabs();
            local content =  UI.Canvas(this.activeContentCanvasID);
            if (content != null){
                content.hide();
            }
            local t = UI.Canvas(this.id+"::tab"+tab.data.id+"::tabContent");
            this.activeContentCanvasID = t.id;
            t.show();

            local c = this.UI.Canvas(this.id+"::tab"+tab.data.id+"::tabHeaderCanvas");
            c.Colour = this.style.activeTabColor;
           c.data.active = true;
            c.setBorderColor("bottom",  this.style.titleColor );
            c.SendToBottom();

            t.Size.X = wrapper.Size.X-2;
            t.Size.Y = wrapper.Size.Y-this.tabsHeight-2;
            if (this.onTabChangeEvent != null) {
                local tabTitle = tab.title;
                this.onTabChangeEvent(tabTitle);
            }
            t.SendToTop();
        }
    }

    function clearActiveTabs(){
        foreach(idx,  tab in this.tabs){
            local c = this.UI.Canvas(this.id+"::tab"+tab.data.id+"::tabHeaderCanvas");
            local content = this.UI.Canvas(this.id+"::tab"+tab.data.id+"::tabContent");
            if (c !=null){
                c.Color = this.style.tabColor;
                c.data.active = false;
                c.setBorderColor("bottom", this.style.headerInactiveBorderColor);
            }

            if (content != null){
                content.hide();
            }
        }
    }

    function showTabContentCanvas(contentCanvasID, tabTitle){
        local wrapper = UI.Canvas(this.id);
        local content = this.UI.Canvas(contentCanvasID);
        this.activeContentCanvasID = contentCanvasID;
        content.show();
        if (this.onTabChangeEvent != null){
            this.onTabChangeEvent(tabTitle);
        }
        content.Size.X = wrapper.Size.X-2;
        content.Size.Y = wrapper.Size.Y-this.tabsHeight-2;
    }

    function applyTabHeaderStyleOnClick(c,tabHeaderCanvasStyle){
        c.Colour = this.style.activeTabColor;
        c.data.active = true;
        c.setBorderColor("bottom",  tabHeaderCanvasStyle.titleColor );
        c.SendToBottom();
    }

    function buildTab(idx, tab){

        if (tab.rawin("data")) {
            tab.data["id"] <- Script.GetTicks() +""+idx;
        } else {
            tab["data"] <- { id =  Script.GetTicks()+""+idx };
        }

        //create the content canvas
        local contentCanvasID = this.id+"::tab"+tab.data.id+"::tabContent";
        local tabContentCanvas = UI.Canvas({id=contentCanvasID, autoResize=true, Colour = this.style.background, align = "middle"});
        //create the header canvas and the label
        local tabHeaderCanvasID =this.id+"::tab"+tab.data.id+"::tabHeaderCanvas";
        local tabHeaderCanvasStyle = getTabHeaderStyle(tab);

        local tabHeaderCanvas = UI.Canvas({
            id = tabHeaderCanvasID
            Position = VectorScreen(this.x, 0)
            context = this
            data = {tabHeaderCanvasStyle = tabHeaderCanvasStyle, active = idx == 0, idx = idx, tabTitle = tab.title, contentCanvasID = contentCanvasID}
            Colour = idx == 0 ? tabHeaderCanvasStyle.activeTabColor : tabHeaderCanvasStyle.tabColor
            Size = VectorScreen(0,0)
            onHoverOver = function(){
                this.Colour = context.style.onHoverTabColor;
            },
            onClick = function(){
                context.clearActiveTabs();
                context.applyTabHeaderStyleOnClick(this, this.data.tabHeaderCanvasStyle);
                context.showTabContentCanvas(this.data.contentCanvasID, this.data.tabTitle)

            }
            onHoverOut = function(){
                if (!this.data.active) {
                    this.Colour = tabHeaderCanvasStyle.tabColor;
                }
            }
            children = [
                UI.Label({
                    id = tabHeaderCanvasID+"::label"
                    TextColour = tabHeaderCanvasStyle.titleColor
                    Text = tab.title
                    FontSize = this.style.titleSize
                    context = this
                    data = { tabHeaderCanvasStyle = tabHeaderCanvasStyle, tabHeaderCanvasID = tabHeaderCanvasID }
                    onHoverOver = function(){
                        this.TextColour = this.data.tabHeaderCanvasStyle.titleColor;
                        local c = this.UI.Canvas(this.data.tabHeaderCanvasID);
                        c.Colour = context.style.onHoverTabColor;
                    }
                    onHoverOut = function(){
                        this.TextColour = this.data.tabHeaderCanvasStyle.titleColor;
                        local c = this.UI.Canvas(this.data.tabHeaderCanvasID);
                        if (c != null && !c.data.active) {
                            c.Colour = this.data.tabHeaderCanvasStyle.tabColor;
                        }

                    }
                     onClick = function(){
                        context.clearActiveTabs();
                        local c = this.UI.Canvas(this.data.tabHeaderCanvasID);
                        context.applyTabHeaderStyleOnClick(c, this.data.tabHeaderCanvasStyle);
                        context.showTabContentCanvas(c.data.contentCanvasID, c.data.tabTitle)

                    }
                })
            ]
            postConstruct = function() {
               local l = UI.Label(tabHeaderCanvasID+"::label");
               this.Size.X = l.Size.X +5;
               this.Size.Y = l.Size.Y +5;

            }
        });
        tabContentCanvas.Size.X = this.Size.X-4;
        tabContentCanvas.Size.Y = this.Size.Y - tabHeaderCanvas.Size.Y-4;
        tabHeaderCanvas.addBottomBorder({ color =  idx == 0 ? tabHeaderCanvasStyle.titleColor : this.style.headerInactiveBorderColor });
        if (tab.rawin("content")){
             foreach (i, child in tab.content){
                if ( child.rawin("className")){

                   
                    tabContentCanvas.add(UI.Canvas(child.id), false);
                    
                }else{
                    if (child.hasWrap()){
                        child.delayWrap=true;
                    }
                    tabContentCanvas.add(child, false);

                }
            }
        }
        return { headerCanvas = tabHeaderCanvas, contentCanvas = tabContentCanvas, children = tab.rawin("content") ? tab.content : [] };
    }


    function build() {
        this.wasResizedDuringBuild= false;
        local wrapper = UI.Canvas({
            id= this.id
            presets = this.presets
            Position =this.Position == null ? VectorScreen(0,0) : this.Position,
            move = this.move,
            context = this
            Size = this.Size
            align = this.align
            ignoreGameResizeAutoAdjust = false
            onGameResize = function(){
                this.realign();
                this.resetMoves();
                this.shiftPos();
            }
        });


        this.x = 0;
        this.y = 0;

        local headerBg = UI.Canvas({
            id = this.id+"::headerBg",
            Colour = this.style.background
            align = "top_right"
            Size = VectorScreen(this.Size.X,0)
            onGameResize = function() {
                this.updateBorders();
            }
        })

        foreach (idx, tab in this.tabs) {

            if (tab.rawin("data")) {
                tab.data["id"] <- Script.GetTicks() +""+idx;
            } else {
                tab["data"] <- { id =  Script.GetTicks()+""+idx };
            }

            local tab = this.buildTab(idx, tab);
            this.x += tab.headerCanvas.Size.X;
            this.tabsHeight = tab.headerCanvas.Size.Y;
            //if the tab's content exceeeds the initial size set for the tabview, re-size the tabview to fit it
            if (tab.contentCanvas.Size.X > wrapper.Size.X){
                wrapper.Size.X = tab.contentCanvas.Size.X;
                this.Size.X = wrapper.Size.X;
                this.wasResizedDuringBuild = true;
            }
             if (tab.contentCanvas.Size.Y > wrapper.Size.Y){
                wrapper.Size.Y = tab.contentCanvas.Size.Y-this.tabsHeight-2;
                this.Size.Y = wrapper.Size.Y;
                 this.wasResizedDuringBuild = true;
            }
            headerBg.Size = VectorScreen(this.Size.X-this.x-2, this.tabsHeight-2);

            wrapper.add(tab.headerCanvas, false);
            wrapper.add(tab.contentCanvas, false);
            tab.contentCanvas.Position.Y += this.tabsHeight;
            tab.contentCanvas.Position.X +=2;


            if (idx > 0){
                tab.contentCanvas.hide();
            }else{
                this.activeContentCanvasID = tab.contentCanvas.id;
                tab.contentCanvas.SendToBottom();
            }

            foreach (i, child in tab.children){
                if (child.rawin("hasWrap") && child.hasWrap()){

                    if (child.hasWrap()){
                        child.forceWrap();
                    }
                }/*
                if (child.rawin("realign")){
                    child.realign();
                }
                if (!child.rawin("className") && child.rawin("move")){
                     child.shiftPos();
                }*/


            }

        }

        wrapper.add(headerBg, false);
        headerBg.Position.Y +=2;
        headerBg.Position.X -=2;
        headerBg.addBottomBorder({});


        if(!this.wasResizedDuringBuild) {
            if (x > wrapper.Size.X) {


                wrapper.Size.X = x;
                local contentCanvas = UI.Canvas(this.id+"::tab"+this.tabs[0].data.id+"::tabContent");
                contentCanvas.Size.X = x;
            }
           // contentCanvas.addBorders({})
        }

        wrapper.addBorders({
            color = this.style.borderColor,
            size = this.style.borderSize
        });

        wrapper.realign();

    }

    function addTab(newTab) {
         local headerBg = UI.Canvas(this.id+"::headerBg");
        if (newTab.rawin("data")) {
            newTab.data["id"] <- Script.GetTicks() +""+this.tabs.len()+1;
        } else {
            newTab["data"] <- { id =  Script.GetTicks()+""+this.tabs.len()+1 };
        }

        local wrapper = UI.Canvas(this.id);
        local tab = this.buildTab(this.tabs.len()+1, newTab);
        //increase X header cursor coordinate
        this.x += tab.headerCanvas.Size.X;
        //set tab height
        this.tabsHeight = tab.headerCanvas.Size.Y;

        //if the tab's content exceeeds the initial size set for the tabview, re-size the tabview to fit it
        if (tab.contentCanvas.Size.X > wrapper.Size.X){
            wrapper.Size.X = tab.contentCanvas.Size.X;
            this.Size.X = wrapper.Size.X;

        }
         if (tab.contentCanvas.Size.Y > wrapper.Size.Y){
            wrapper.Size.Y = tab.contentCanvas.Size.Y-this.tabsHeight-2;
            this.Size.Y = wrapper.Size.Y;

        }
        //set header size to the (wrapperSize - maxCursorX)
        headerBg.Size.X = wrapper.Size.X-this.x;
        //increase X Position by the same amount of the header size
        headerBg.Position.X += tab.headerCanvas.Size.X;
        headerBg.updateBorders();

        wrapper.add(tab.headerCanvas, false);
        wrapper.add(tab.contentCanvas, false);

        tab.contentCanvas.Position.Y += this.tabsHeight;
        tab.contentCanvas.Position.X +=2;
        tab.contentCanvas.hide();
        tab.headerCanvas.SendToBottom();



        this.tabs.push(newTab);
       this.resizeWrapperDimensionsAfterAddingTab();

    }


    function removeTab(idx) {
        if ((idx == 0 && this.tabs.len() == 1) || idx < 0 || idx >= this.tabs.len()){
            return;
        }
        local wrapper = UI.Canvas(this.id);
        local headerBg = UI.Canvas(this.id+"::headerBg");
        if (idx < this.tabs.len()-1 ){  //if the tab that is removed is not the last one, readjust all tab headers
            /*
            1. get the IDs of the canvas' headers ahead of this tab
            2. get tab and delete it from the array
            3. delete tab content canvas
            4. get the width of the header to delete
            5. delete tab header canvas
            6. with the IDs that were gathered, use them to re-position the tab header canvas'
            */

            //1.
            local ids = [];
            local tab = this.tabs[idx];
            if (tab == null){
                return;
            }
            for (local i = 0; i<this.tabs.len(); i++){

                if (i > idx){
                   ids.push(this.tabs[i].data.id);
                }
            }

            //2.
            this.tabs.remove(idx);
            //3.
            local contentCanvas = UI.Canvas(this.id+"::tab"+tab.data.id+"::tabContent");
             contentCanvas.destroy();
            //4.
            local headerCanvas = UI.Canvas(this.id+"::tab"+tab.data.id+"::tabHeaderCanvas");
            local width =  headerCanvas.Size.X;
            //5.
            headerCanvas.destroy();
            //6.
            local contentCanvasToShow = null;
            foreach (index, tabID in ids) {
                local header = UI.Canvas(this.id+"::tab"+tabID+"::tabHeaderCanvas");
                header.Position.X -= width;

                if (index == 0){
                    this.clearActiveTabs();
                    header.Colour = this.style.activeTabColor;
                    header.data.active = true;
                    header.setBorderColor("bottom",  this.style.titleColor );
                    header.SendToBottom();
                    contentCanvasToShow = UI.Canvas(this.id+"::tab"+tabID+"::tabContent");
                }
            }
            this.x -= width;
            if (this.x > this.initialSize){
                 if (this.x > this.Size.X){
                    wrapper.Size.X -= width;
                    wrapper.updateBorders();
                    contentCanvasToShow.Size.X -= width;
                 }
            }
            headerBg.Size.X = wrapper.Size.X-this.x;
            headerBg.Position.X -= width;
            headerBg.updateBorders();
            if (wrapper.Size.X > contentCanvasToShow.Size.X){
                contentCanvasToShow.Size.X = wrapper.Size.X;
            }
             if (wrapper.Size.Y-this.tabsHeight > contentCanvasToShow.Size.Y){
                contentCanvasToShow.Size.Y = wrapper.Size.Y-this.tabsHeight;
            }
            contentCanvasToShow.show();
            this.activeContentCanvasID = contentCanvasToShow.id;

        } else{


            local contentCanvas = UI.Canvas(this.id+"::tab"+this.tabs[idx].data.id+"::tabContent");
            local headerCanvas = UI.Canvas(this.id+"::tab"+this.tabs[idx].data.id+"::tabHeaderCanvas");

            local overflow = this.x > this.Size.X;
            local overflowVal = this.x-this.Size.X;
            this.x -= headerCanvas.Size.X;


            if (this.x > this.initialSize){
                 if (this.x > this.Size.X){
                    wrapper.Size.X -= headerCanvas.Size.X;
                    wrapper.updateBorders();
                    UI.Canvas(activeContentCanvasID).Size.X -= headerCanvas.Size.X;
                 }
            }

            headerBg.Size.X = wrapper.Size.X-this.x;
            headerBg.Position.X -= headerCanvas.Size.X;
            headerBg.updateBorders();

            contentCanvas.destroy();
            headerCanvas.destroy();
            headerBg.updateBorders();
            this.resizeWrapperDimensionsAfterAddingTab();

            if (this.activeContentCanvasID == this.id+"::tab"+this.tabs[idx].data.id+"::tabContent") {
                this.changeTab(0);
            }

             this.tabs.remove(idx);
        }

    }

     function resizeWrapperDimensionsAfterAddingTab() {
         local headerBg = UI.Canvas(this.id+"::headerBg");
        if (this.x > this.initialSize){
            local wrapper = UI.Canvas(this.id);

            if (this.x > this.Size.X){
                 wrapper.Size.X = this.x;
                UI.Canvas(this.activeContentCanvasID).Size.X = this.x;
            }

            wrapper.updateBorders();
            headerBg.updateBorders();
            wrapper.realign();
            wrapper.resetMoves();
            wrapper.shiftPos();
        }
    }


}

UI.registerComponent("TabView", {
    create = function(o) {
        local c = Tabview(o);
        return c;

    }
});