class Tabview  extends Component {

    tabs = null;
    className = "TabView";
    Position = null;
    align = null;
    move = null;
    style = null; 
    Size = null;
    onTabChangeEvent = null; 
    tabHeight = null;
    tabsSize = null;
    x = null;
    y = null;
    currentTabIdx = null; 
    lastHeight = null;
    lastWidth = null;
    maxContentSize = null;
    initialSize =null;


    constructor(o) { 
        
        this.id = Script.GetTicks();
        this.tabs = [];
        this.move = {};
        this.tabHeight = 0;
        this.tabsSize = 0;
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

        if (o.rawin("move")){
            this.move = o.move;
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
        
        if (o.rawin("id")){
            this.id = o.id;
        }
        if (o.rawin("Position")){
            this.Position = o.Position;
        } 
        if (o.rawin("align")){
            this.align = o.align; 
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
        base.constructor(this.id,o);
        this.metadata.list ="tabviews";
        this.build();  
 
    }   

    function changeTab(tabIdx){ 
        local firstDraw = this.currentTabIdx == -1;
        local tab = this.tabs[tabIdx];
        this.clearActiveTabs();
        local t = UI.Canvas(this.id+"::tab"+tab.data.id+"::content");
        if (t != null){
          
            this.currentTabIdx = tabIdx;
            t.show(); 
            
            local c = this.UI.Canvas(this.id+"::tab"+tab.data.id+"::canvas");
            c.Colour = this.style.activeTabColor;
            c.data.active = true;
              local wrapper = UI.Canvas(this.id);
            c.setBorderColor("bottom", c.data.tc );
            c.SendToBottom();
            this.resizeTabContentCanvas(wrapper, tabIdx );
            if (this.onTabChangeEvent != null && !firstDraw) {
                local tabTitle = this.tabs[tabIdx].title;
                this.onTabChangeEvent(tabTitle);
            }
            t.SendToTop();

        }
    }

    function getTabByDataID(id){
        for (local i = 0; i<this.tabs.len(); i++){
            if (this.tabs[i].data.id == id){
                return this.tabs[i];
            }
        }
    }
    
 
    function removeTab(idx) {   
  
        if (idx < this.tabs.len()-1 ){  //if the tab that is removed is not the last one, readjust all tab headers
            this.tabHeight = 0;
            this.tabsSize = 0;
            this.x = 0; 
            this.currentTabIdx = 0;
            local cid = this.id+"::tab"+this.tabs[idx].data.id+"::content"; 
        

           UI.Canvas(cid).destroy();

            for (local i = 0; i<this.tabs.len(); i++){
                
                local canv = UI.Canvas(this.id+"::tab"+this.tabs[i].data.id+"::canvas");
                if (canv != null)
                    canv.destroy();
            }
             this.tabs.remove(idx);  
             local canv = UI.Canvas(this.id+"::tabsHeader::canvas");
             local canvSize = canv.Size.X;
             canv.destroy(); 
 
            local wrapper = UI.Canvas(this.id); 
              foreach (tabIdx, tabb in this.tabs) { 
                local o = this.buildTab(tabIdx, tabb, tabHeight, tabsSize, wrapper, x, true);
                this.x = o.x;
                this.tabHeight = o.tabHeight;
                this.tabsSize = o.tabsSize;
                wrapper = o.wrapper;  
                 UI.Canvas(this.id+"::tab"+tabb.data.id+"::canvas").SendToBottom();
            }
            wrapper =  this.buildTabsHeader(wrapper, VectorScreen(wrapper.Size.X-tabsSize, tabHeight), tabsSize);

           
            cid = this.id+"::tab"+this.tabs[0].data.id+"::content"; 
            local cont = UI.Canvas(cid);  
            wrapper.Size = VectorScreen(lastWidth, lastHeight);    
            wrapper.updateBorders();
            cont.Size = VectorScreen(lastWidth, lastHeight-tabHeight); 
            cont.show();  
        
 
            local s = wrapper.Size.X-this.Size.X; 
        
            if (wrapper.Size.X > this.Size.X){ 
                local headerLine = UI.Canvas(this.id+"::tabsHeader::canvas");
                if (x < this.Size.X) {
                    lastWidth = this.Size.X;    
                    wrapper.Size.X =this.Size.X;
                     wrapper.realign();

                } else{
                    wrapper.Size.X = x ;
                     wrapper.realign();
                } 
                
                wrapper.updateBorders(); 
               
                headerLine.Position.X = x;  
                headerLine.Size.X =  wrapper.Size.X- x;
                headerLine.updateBorders(); 
               
            }
           
             
           
       }else{  


            local cont = UI.Canvas(this.id+"::tab"+this.tabs[idx].data.id+"::content").destroy();
            local canv = UI.Canvas(this.id+"::tab"+this.tabs[idx].data.id+"::canvas");
    
            local headerLine = UI.Canvas(this.id+"::tabsHeader::canvas");
            local wrapper = UI.Canvas(this.id);
            
            
            this.x -= canv.Size.X;
            this.tabsSize -= wrapper.Size.X;
            local width = canv.Size.X;



            if (x < this.Size.X){
                if (wrapper.Size.X > this.Size.X){ 
                    local s = wrapper.Size.X-this.Size.X;
                    wrapper.Size.X =this.Size.X;
                    wrapper.updateBorders(); 
                    headerLine.Position.X -= canv.Size.X; 
                    headerLine.Size.X += canv.Size.X-s;
                }else{
                    headerLine.Position.X -= canv.Size.X; 
                    headerLine.Size.X +=canv.Size.X;  
                }
            }else{  
                headerLine.Position.X = x; 
                headerLine.Size.X =0;   
                wrapper.Size .X -= canv.Size.X;
                wrapper.updateBorders();
            }
            
        
            headerLine.removeBorders();
            headerLine.addBottomBorder({
                color = this.style.headerBorderColor,
                size = this.style.headerBorderSize
            });
        
        
            canv.destroy();

        
            this.tabs.remove(idx);  
            wrapper.realign();
            if (idx == this.currentTabIdx){
                if (idx > 0){
                    this.changeTab(0); 
                    this.resizeTabContentCanvas(wrapper,0);   
                }
               
            }  
  
       }
       //
 
    }



    function indexOfTab(t){  
        foreach(idx,  tab in this.tabs){
            if (tab.title == t){
                return idx;
            }
        } 
        return null;
    } 
 
    function addTab(tab) { 
       
        if (!tab.rawin("data")){
            tab["data"] <- { id =Script.GetTicks() +""+this.tabs.len()};
        }
       
        local wrapper = UI.Canvas(this.id);

        wrapper.removeBorders();
        local o = this.buildTab(this.tabs.len(), tab, this.tabHeight, this.tabsSize, wrapper, this.x, false);
        this.tabs.push(tab);
        this.x = o.x;
        this.tabHeight = o.tabHeight; 
        this.tabsSize = o.tabsSize; 

        this.setDimensions(wrapper);
        
        this.alignAndBorderWrapper(wrapper);

        local headerLine = UI.Canvas(this.id+"::tabsHeader::canvas");
      
        if (x < this.Size.X){  
            headerLine.Position.X += o.canvas.Size.X;
            headerLine.Size.X -= o.canvas.Size.X; 
        }else{

             headerLine.Position.X = x;
             headerLine.Size.X = 0;
        }
      
        local canv = UI.Canvas(this.id+"::tab"+this.tabs[this.currentTabIdx].data.id+"::canvas");
 
        canv.removeBorders();  
       
        canv.addBottomBorder({ 
       //     move = { down = 2 } ,
            color = this.style.titleColor
        });

        foreach (idx, tab in this.tabs) {
            if (idx != currentTabIdx){
                local c = UI.Canvas(this.id+"::tab"+tab.data.id+"::canvas");
                c.removeBorders();
                c.addBottomBorder({ 
               //     move = { down = 2 } 
                   
                });
            }
        }
 
        headerLine.removeBorders();
        headerLine.addBottomBorder({
           color = this.style.headerBorderColor,
            size = this.style.headerBorderSize
        });
        this.lastHeight = wrapper.Size.Y;
        this.lastWidth = wrapper.Size.X;
        o.tabContent.SendToBottom();
       
    } 

    function clearActiveTabs(){
        foreach(idx,  tab in this.tabs){
            local c = this.UI.Canvas(this.id+"::tab"+tab.data.id+"::canvas");
            local content = this.UI.Canvas(this.id+"::tab"+tab.data.id+"::content");
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

    function buildTabsHeader(c,size, x){

        local h = UI.Canvas({
            id = this.id+"::tabsHeader::canvas",
            Size =size,
            Position = VectorScreen(x, 0),
            context = this,
            onClick = function () {
                this.SendToBottom(); 
            }
           
        }); 
         c.add(h); 
        h.addBottomBorder({
            color = this.style.headerBorderColor,
            size = this.style.headerBorderSize
        });
       
        
        h.SendToBottom(); 
        return c; 
    }
      
    function buildTab(idx, tab, tabHeight, tabsSize, wrapper, x, rebuild) {             
              
            local contentID = tab.data.id; 

            local tabContent = rebuild ? UI.Canvas(this.id+"::tab"+contentID+"::content") : UI.Canvas({ id = this.id+"::tab"+contentID+"::content"  }) ;
            tabContent.Size = this.Size;

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
            
            local label =UI.Label({
                id = this.id+"::tab"+contentID+"::label"
                Text = tab.title 
            });
            
            if (this.style.rawin("titleSize") && this.style.titleSize != null) {
                label.FontSize = this.style.titleSize; 
            }
            local tabCanvas =UI.Canvas({ 
                id = this.id+"::tab"+contentID+"::canvas",
                Size = VectorScreen(label.Size.X+5, label.Size.Y+5),
                Position = VectorScreen(x, 0),
                data = { defaultColor = color, active = false, idx = idx, tab = tab.title, wrapper = wrapper, content = contentID, ac = ac, tc = tc, tabColor= color},
                Colour = color,
                context = this,
                 metadata = { contentID = contentID},
                onHoverOver = function(){ 
                    this.Colour = context.style.onHoverTabColor;
                }, 
                 onHoverOut = function(){
                    
                    if (!this.data.active) {
                        this.Colour = this.data.tabColor;
                    }
                }, 
                onClick = function(){ 
                    context.clearActiveTabs();
                    this.Colour = context.style.activeTabColor;
                    this.data.active = true;
                    this.setBorderColor("bottom",  this.data.tc );
                    this.SendToBottom(); 

                     local cid = context.id+"::tab"+this.data.content+"::content";
                    local content = this.UI.Canvas(cid);
                    content.show();
                    if (context.onTabChangeEvent != null){ 
                        context.onTabChangeEvent(this.data.tab);
                    }
                    context.resizeTabContentCanvas(wrapper, this.data.idx );
                    
                }
            });   

            label.destroy();
             label = UI.Label({
                id = this.id+"::tab"+contentID+"::label",
                Text = tab.title,
                context = this, 
                data = { idx = idx, tab = tab.title, wrapper = wrapper ,content = contentID, ac = ac, tc = tc, tabColor= color},
                onHoverOver = function(){
                   this.TextColour = this.data.tc;
                    local c = this.UI.Canvas(context.id+"::tab"+this.data.content+"::canvas");
                    c.Colour = context.style.onHoverTabColor;
                },
                 onHoverOut = function(){      
                      
                   this.TextColour = this.data.tc; 

                    local c = this.UI.Canvas(context.id+"::tab"+this.data.content+"::canvas");
                    if (c != null && !c.data.active) {
                         c.Colour = this.data.tabColor; 
                    } 
                  
                },
                onClick = function(){
                    
                    context.clearActiveTabs(); 
                    local c = this.UI.Canvas(context.id+"::tab"+this.data.content+"::canvas");
                    c.Colour = context.style.activeTabColor;
                    c.data.active = true;
                    c.setBorderColor("bottom",  this.data.tc ); 
                    c.SendToBottom();
                   
                    local cid = context.id+"::tab"+this.data.content+"::content";
                    local content = this.UI.Canvas(cid);

                    content.show();
                    if (context.onTabChangeEvent != null){
                        context.onTabChangeEvent(this.data.tab); 
                       
                    }
                     context.resizeTabContentCanvas(wrapper, this.data.idx );
                   
                }
                postConstruct = function () {
                    
                }
            });

            if (this.style.rawin("titleSize") && this.style.titleSize != null) {
                label.FontSize = this.style.titleSize; 
            }
            
            label.TextColour = tc; 
           
            
            tabHeight = tabCanvas.Size.Y;
            tabsSize += tabCanvas.Size.X;
           
            wrapper.Size.Y = tabCanvas.Size.Y;
                
      
            x += tabCanvas.Size.X;  
         
          //  if (!rebuild){ 
                tabContent.Position.Y = tabCanvas.Size.Y;
          //  }
            if (idx == 0){ 
                tabCanvas.Colour = ac;
                tabCanvas.data.active = true;
                tabCanvas.setBorderColor("bottom",  tc );
                tabCanvas.SendToBottom();
            }
           
            wrapper.add(tabCanvas);  
            tabCanvas.addBottomBorder({ color = this.style.headerInactiveBorderColor });
            tabCanvas.add(label);
            wrapper.add(tabContent);
            
            if (tab.rawin("content")){  
                 foreach (i, child in tab.content){
                    if ( child.rawin("className")){  
             
                        if (child.className == "InputGroup"){
                            child.attachParent(tabContent,0);
                        } else if (child.className == "GroupRow"){  
                            child.parentID = tabContent.id;
                            child.calculatePositions();
                        } else {
                            tabContent.add(UI.Canvas(child.id)); 
                        }
                    }else{ 
                        tabContent.add(child); 
                        
                         if (child.Position.X + child.Size.X > this.maxContentSize.X){
                            this.maxContentSize.X = child.Position.X + child.Size.X;
                        }
                         if (child.Position.Y + child.Size.Y > this.maxContentSize.Y){
                            this.maxContentSize.Y = child.Position.Y + child.Size.Y;
                        }
                       
                    }
                }
            }
            if (!rebuild){
                wrapper.Size.Y = this.Size.Y;
                wrapper.Size.X = this.Size.X;
                if (wrapper.Size.X < x){
                    wrapper.Size.X = x;
                    this.Size.X = x;
                }
            }
            return { tabHeight = tabHeight,tabsSize = tabsSize, wrapper = wrapper, x = x, canvas = tabCanvas, tabContent = tabContent };
    }

    function build() { 
        
        this.tabHeight = 0;
        this.tabsSize = 0;
        local wrapper = UI.Canvas({
            id= this.id,
            Position =this.Position == null ? VectorScreen(0,0) : this.Position,
            move = this.move,
            context = this
        });
        wrapper.Size.X =this.Size.X;
        wrapper.Size.Y = this.Size.Y;
        
        if (this.align != null) {
            wrapper.align = this.align;
        }
        this.x = 0;
        this.y = 0;
         
        foreach (idx, tab in this.tabs) {

            if (tab.rawin("data")) {
                tab.data["id"] <- Script.GetTicks() +""+idx;
            } else {
                tab["data"] <- { id =  Script.GetTicks()+""+idx };
            }
           
            local o = this.buildTab(idx, tab, tabHeight, tabsSize, wrapper, x, false);
            this.x = o.x;
            this.tabHeight = o.tabHeight;
            this.tabsSize = o.tabsSize;
             wrapper = o.wrapper; 
        } 
          
         if (wrapper.Size.X < this.maxContentSize.X){
                
            this.Size.X = this.maxContentSize.X+5;
            x= this.maxContentSize.X+5;
        } 

         if (wrapper.Size.Y - this.tabHeight < this.maxContentSize.Y){
                
            this.Size.Y = this.maxContentSize.Y+5;
            y = this.maxContentSize.Y+5;
        } 
              

         this.setDimensions(wrapper); 
        wrapper =  this.buildTabsHeader(wrapper, VectorScreen(wrapper.Size.X-tabsSize, tabHeight), tabsSize);
        this.alignAndBorderWrapper(wrapper);
        this.changeTab(0);
        this.alignTabContents(wrapper);
        lastHeight = wrapper.Size.Y;
        lastWidth = wrapper.Size.X;
        wrapper.SendToBottom();
        this.Size.X = wrapper.Size.X;
        this.Size.Y = wrapper.Size.Y;
        

        
    } 

    function setDimensions(wrapper){
         wrapper.Size.X = x;
         wrapper.Size.X = y;

        if (this.Size != null){
            if (this.Size.X > wrapper.Size.X){
                wrapper.Size.X = this.Size.X;
            }
            if (this.Size.Y > wrapper.Size.Y){
                wrapper.Size.Y = this.Size.Y+tabHeight;
            } 
           
        }
    }

    function alignAndBorderWrapper(wrapper){
         wrapper.Colour = this.style.background;
        wrapper.realign();
        wrapper.addBorders({
            color = this.style.borderColor,
            size = this.style.borderSize
        });  
        wrapper.shiftPos();
    }

    function resizeTabContentCanvas(wrapper, tabIdx){
         local tab = this.tabs[tabIdx];
         local c = UI.Canvas(this.id+"::tab"+tab.data.id+"::content");
         if (c != null) {
             c.Size.X = wrapper.Size.X;
             c.Size.Y =wrapper.Size.Y-tabHeight;
             c.updateBorders();

             
            if (this.tabs.len() > tabIdx){                 
                if (tab.rawin("content")){
                    foreach (i, child in tab.content){
                       child.realign();
                       if (child.rawin("move")){
                           if (typeof child == "instance"){
                               local el = UI.Canvas(child.id);
                             
                               el.shiftPos();
                           }
                           
                       }
                    }
                }
            }
         }
    } 

    function alignTabContents(wrapper){  
 
         foreach (idx, tab in this.tabs) {

            local c = UI.Canvas(this.id+"::tab"+tab.data.id+"::content");
            
            if (tab.rawin("content")){
               foreach (i, child in tab.content){
                   c.Size.Y= wrapper.Size.Y-tabHeight;
                   c.Size.X= wrapper.Size.X;
                  
                  child.realign();
                  if (child.rawin("move") && child.move != null ){
                    child.shiftPos(); 
                  }
               }
            }
         }
    }
    
}