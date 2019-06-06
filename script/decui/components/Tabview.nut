class Tabview  extends Component {

    tabs = null;
    className = "TabView";
    Position = null;
    align = null;
    move = null;
    style = null; 
    size = null;
    onTabChangeEvent = null; 
    tabHeight = null;
    tabsSize = null;
    x = null;
    currentTabIdx = null;
    lastHeight = null;
    lastWidth = null;


    constructor(o) {
       
        this.id = Script.GetTicks();
        this.tabs = [];
        this.move = {};
        this.tabHeight = 0;
        this.tabsSize = 0;
        this.x = 0; 
        this.currentTabIdx = 0; 
       
        this.style = {
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
        };

        if (o.rawin("tabs")){
            this.tabs = o.tabs;
        }
        if (o.rawin("onTabClicked")){
            this.onTabChangeEvent = o.onTabClicked;
        }
        if (o.rawin("size")){
            this.size = o.size;
        }

        if (o.rawin("move")){
            this.move = o.move;
        }
         if (o.rawin("style")){
             this.style = o.style;
             if (style.rawin("titleSize")) {
                this.style.titleSize = o.style.titleSize;
            }
            if (style.rawin("titleColor")){
                this.style.titleColor = o.style.titleColor; 
            }  
            if (style.rawin("tabColor")) {
                this.style.tabColor = o.style.tabColor;
            }    
            if (style.rawin("onHoverTabColor")) {
                this.style.onHoverTabColor = o.style.onHoverTabColor;
            }
             if (style.rawin("activeTabColor")) {
                this.style.activeTabColor = o.style.activeTabColor;
            }
             if (style.rawin("background")) {
                this.style.background = o.style.background;
            }
              if (style.rawin("borderColor")) {
                this.style.borderColor = o.style.borderColor;
            }
             if (style.rawin("borderSize")) {
                this.style.borderSize = o.style.borderSize;
            }
             if (style.rawin("headerBorderColor")) {
                this.style.headerBorderColor = o.style.headerBorderColor;
            }
             if (style.rawin("headerBorderSize")) {
                this.style.headerBorderSize = o.style.headerBorderSize;
            }

            //
            
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
        base.constructor(this.id);
        this.build();  
 
    }   

    function changeTab(tabIdx){ 
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
            c.setBorderColor("bottom",  this.style.titleColor );
            c.SendToBottom();
            this.resizeTabContentCanvas(wrapper, tabIdx );
            if (this.onTabChangeEvent != null) {
                local tabTitle = this.tabs[tabIdx].title;
                this.onTabChangeEvent(tabTitle);
            }
            t.SendToTop();
              //printElementData(t) ; 

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
        
 
            local s = wrapper.Size.X-this.size.X; 
        
            if (wrapper.Size.X > this.size.X){ 
                local headerLine = UI.Canvas(this.id+"::tabsHeader::canvas");
                if (x < this.size.X) {
                    lastWidth = this.size.X;    
                    wrapper.Size.X =this.size.X;
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
        
        
            if (x < this.size.X){
                if (wrapper.Size.X > this.size.X){ 
                    local s = wrapper.Size.X-this.size.X;
                    wrapper.Size.X =this.size.X;
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
                this.changeTab(0); 
                this.resizeTabContentCanvas(wrapper,0);   
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
      
        if (x < this.size.X){  
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
                c.setBorderColor("bottom", Colour(255,255,255));
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
         c.addChild(h);
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

             local color = null;
             if (tab.rawin("style") && tab.style.tabColor != null ){
               color =  tab.style.tabColor;
            } else{
               color  =  this.style.tabColor;
            }  

            local label = UI.Label({
                id = this.id+"::tab"+contentID+"::label",
                Text = tab.title,
                context = this, 
                data = { idx = idx, tab = tab.title, wrapper = wrapper ,content = contentID},
                onHoverOver = function(){
                   this.TextColour = context.style.titleColor;
                    local c = this.UI.Canvas(context.id+"::tab"+this.data.content+"::canvas");
                    c.Colour = context.style.onHoverTabColor;
                },
                 onHoverOut = function(){      
                     
                   this.TextColour = context.style.titleColor; 

                    local c = this.UI.Canvas(context.id+"::tab"+this.data.content+"::canvas");
                    if (c != null && !c.data.active) {
                         c.Colour = context.style.tabColor; 
                    } 
                  
                },
                onClick = function(){
                    
                    context.clearActiveTabs(); 
                    local c = this.UI.Canvas(context.id+"::tab"+this.data.content+"::canvas");
                    c.Colour = context.style.activeTabColor;
                    c.data.active = true;
                    c.setBorderColor("bottom",  context.style.titleColor ); 
                    c.SendToBottom();
                   
                    local cid = context.id+"::tab"+this.data.content+"::content";
                    local content = this.UI.Canvas(cid);
                   // ::getroottable().printElementData(content);
                    content.show();
                    if (context.onTabChangeEvent != null){
                        context.onTabChangeEvent(this.data.tab); 
                       
                    }
                     context.resizeTabContentCanvas(wrapper, this.data.idx );
                   
                }
            });

            if (this.style.titleSize != null) {
                label.FontSize = this.style.titleSize; 
            }
            if (tab.rawin("style") ){
                label.TextColour = tab.style.titleColor;
            }else{
                label.TextColour = this.style.titleColor;
            }

            local tabCanvas =UI.Canvas({
                id = this.id+"::tab"+contentID+"::canvas",
                Size = VectorScreen(label.Size.X+5, label.Size.Y+5),
                Position = VectorScreen(x, 0),
                data = { defaultColor = color, active = false, idx = idx, tab = tab.title, wrapper = wrapper, content = contentID},
                Colour = color,
                context = this,
                 metadata = { contentID = contentID},
                onHoverOver = function(){ 
                    this.Colour = context.style.onHoverTabColor;
                }, 
                 onHoverOut = function(){
                    
                    if (!this.data.active) {
                        this.Colour = context.style.tabColor;
                    }
                }, 
                onClick = function(){
                    context.clearActiveTabs();
                    this.Colour = context.style.activeTabColor;
                    this.data.active = true;
                    this.setBorderColor("bottom",  context.style.titleColor );
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
           

            tabHeight = tabCanvas.Size.Y;
            tabsSize += tabCanvas.Size.X;
           
            wrapper.Size.Y = tabCanvas.Size.Y;
                
 
            x += tabCanvas.Size.X;  
         
          //  if (!rebuild){
                tabContent.Position.Y = tabCanvas.Size.Y;
          //  }
            if (idx == 0){
                tabCanvas.Colour = this.style.activeTabColor;
                tabCanvas.data.active = true;
                tabCanvas.setBorderColor("bottom",  this.style.titleColor );
                tabCanvas.SendToBottom();
            }
            
           
            wrapper.addChild(tabCanvas);  
            tabCanvas.addBottomBorder({  });
            tabCanvas.addChild(label);
            wrapper.addChild(tabContent);
 
            if (tab.rawin("content")){ 
                 foreach (i, child in tab.content){
                    if ( child.rawin("className")){ 
            
                        if (child.className == "InputGroup"){
                            child.attachParent(tabContent,0);
                        } else if (child.className == "GroupRow"){  
                            child.parentID = tabContent.id;
                            child.calculatePositions();
                        }
                    }else{
                      
                        tabContent.addChild(child); 
                       
                    }
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
      
        
        if (this.align != null) {
            wrapper.align = this.align;
        }
        this.x = 0;
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
          
        this.setDimensions(wrapper); 
        wrapper =  this.buildTabsHeader(wrapper, VectorScreen(wrapper.Size.X-tabsSize, tabHeight), tabsSize);
       
        this.alignAndBorderWrapper(wrapper);
        this.changeTab(0);
       
        this.alignTabContents(wrapper);
        lastHeight = wrapper.Size.Y;
        lastWidth = wrapper.Size.X;
        wrapper.SendToBottom();
    }

    function setDimensions(wrapper){
         wrapper.Size.X = x;

        if (this.size != null){
            if (this.size.X > wrapper.Size.X){
                wrapper.Size.X = this.size.X;
            }
            if (this.size.Y > wrapper.Size.Y){
                wrapper.Size.Y = this.size.Y;
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
                 //  child.shiftPos();
               }
            }
         }
    }
    
}