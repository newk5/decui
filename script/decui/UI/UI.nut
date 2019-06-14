
class UI  {

    toDelete=null;
   
    kps = null;
    res = null;
   
    hoveredEl=null;
    clickedEl=null;
    
    openContextID = null;
    debug = true;
    lists = null; 
    names = null;
    openCombo = null; 
    comboClick = 0; 
    idsMetadata = null;
    listsNumeration = null;
    fetch = null;
    events = null;
 
    
    constructor() {

        this.toDelete =[];
        this.kps  = []; 
        idsMetadata = {}; 
        listsNumeration = {};

        lists = [ [], [], [], [], [], [], [], [], [],[],  [], [], [], [], [] ];
        names = [ "labels"   ,    "buttons",    "sprites",    "windows",    "progbars",     "canvas",   "scrollbars",    "memoboxes",     "editboxes",   "listboxes" ,  "checkboxes", "popups", "datatables", "comboboxes", "tabviews" ];
        foreach (idx, name in names) {
           listsNumeration[name] <- 0;
        } 
        this.fetch = Fetch(this);
        this.events = Events(this);
    }
 
    

    function removeBorders(e){
        foreach (idx, c in this.lists[this.names.find("canvas")]) {
            if (c.parents.find(e.id) != null && c.rawin("data") && c.data.rawin("isBorder") && c.data.isBorder != null && c.data.isBorder){
                c.remove();
            }
            
        }
    }

     function updateBorders(e){
        foreach (idx, c in this.lists[this.names.find("canvas")]) {
            if (c.parents.find(e.id) != null && c.rawin("data") && c.data.rawin("isBorder") && c.data.isBorder != null && c.data.isBorder){
                if (c.Size.X > e.Size.X){
                    c.Size.X = e.Size.X;
                }
                if (c.Size.Y > e.Size.Y){
                     c.Size.Y = e.Size.Y;
                }
                c.realign();
            }
            
        }
    }

    function addBorder(e, b, align) { 
        local id = e.id == null ? Script.GetTicks() : e.id;
        local size = null;   
        local borderPos = null;
        local parentsList =   e.id == null ? e.parents : mergeArray(e.parents, e.id);
        local move = {};
       
 
        if (align == "top_left"){
            borderPos = "left";
        }else if (align =="top_right"){
            borderPos = "right";
        } else if (align == "top_center"){
            borderPos = "top";
        }else{
            borderPos = "bottom";
        }
        if (b.rawin("move")){
            move = b.move;
        }

        if (align == "top_left" || align == "top_right"){
            size = VectorScreen(b.rawin("size") ? b.size : 2, e.Size.Y);
        }else{
            size = VectorScreen(e.Size.X, b.rawin("size") ? b.size : 2);
        }
        local border = this.Canvas({ 
                id = id+"::"+align+"::border",
                data = { isBorder = true, borderPos = borderPos},
                Colour = b.rawin("color") ? b.color : Colour(255,255,255), 
                align  = align, 
                Size = size,
                parents = parentsList,
                move = move
        });
        if (e.rawin("data") && e.data != null){
            if (e.data.rawin("borderIDs")){
                if (e.data.borderIDs.find(border.id)==null){
                    e.data.borderIDs.push(border.id);
                }
            }else{
                e.data["borderIDs"] <- [border.id];
            }
        }else{
            e.data["borderIDs"] <- [border.id];
        }

       
        e.add(border);
        border.realign(); 
        border.shiftPos();
    }

    function align(e) { 
        if (e.align != null){
            local a = e.align.tolower();
            local wrapper = null; 
            if (e.parents.len() == 0){ 
                wrapper = GUI.GetScreenSize(); 
            }else{ 
                local lastID = e.parents[e.parents.len()-1];
               
                local parent = findById(lastID);
                wrapper =  parent == null ? GUI.GetScreenSize() : parent.Size;
            }
            
            if (a == "top_right"){
                e.Position.Y = 0;
                e.Position.X = wrapper.X - e.Size.X;
            } else if (a == "top_left"){
                e.Position.Y = 0;
                e.Position.X = 0;
            } else if (a == "top_center"){
                e.Position.Y = 0;
                e.Position.X = wrapper.X / 2 - e.Size.X /2;
            } else if (a == "bottom_right"){
                e.Position.Y = wrapper.Y - e.Size.Y;
                e.Position.X = wrapper.X - e.Size.X;
            } else if (a == "bottom_left"){
                e.Position.Y =  wrapper.Y - e.Size.Y;
                e.Position.X = 0;
            } else if (a == "bottom_center" || a == "bottom"){
                e.Position.Y = wrapper.Y - e.Size.Y;
                e.Position.X = wrapper.X / 2 - e.Size.X /2;
            } else if (a == "mid_center" || a == "center"){
                e.Position.Y = wrapper.Y / 2 - e.Size.Y /2;
                e.Position.X = wrapper.X / 2 - e.Size.X /2;
           } else if (a == "mid_left"){
                e.Position.Y = wrapper.Y / 2 - e.Size.Y /2;
                e.Position.X = 0;
            } else if (a == "mid_right"){
                e.Position.Y = wrapper.Y / 2 - e.Size.Y /2;
                e.Position.X = wrapper.X - e.Size.X;
            } else if (a == "radar_right"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 3.9);
                e.Position.X =  (wrapper.X /4.5);
            } else if (a == "radar_left"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 3.9);
                e.Position.X = 0;
            } else if (a == "radar_bottom"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 15);
                e.Position.X = (wrapper.X /25);
            } else if (a == "radar_top"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 3.1);
                e.Position.X = (wrapper.X /25);
            } else if (a == "hud_bottom"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 1.26);
                e.Position.X =(wrapper.X /1.18); 
            }  else if (a == "hud_top"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 1.0290);
                e.Position.X =(wrapper.X /1.18);
            } else if (a == "hud_right"){
                e.Position.Y =  wrapper.Y -(wrapper.Y / 1.0712);
                e.Position.X = wrapper.X - (wrapper.X /20);;
            }
        }
        
    }
    
    function shift(e){
        if (e.move != null){
            local s = e.move;
            
            if(typeof s  != "function"){
                if (s != null && s.rawin("left")){
                    e.Position.X =  e.Position.X - s.left;
                }
                if (s.rawin("right")){
                    e.Position.X =  e.Position.X + s.right;
                }
                if (s.rawin("up")){
                    e.Position.Y =  e.Position.Y - s.up;
                }
                if (s.rawin("down")){
                    e.Position.Y =  e.Position.Y + s.down;
                }
            }
        }
    }

    function Cursor(status) {
        if (status=="on" || status =="ON"){
            GUI.SetMouseEnabled(true);
        }else{ 
            GUI.SetMouseEnabled(false); 
        }
    }    
 
    function addToDeleteQueue(e) { 
      //  p("deleted "+this.cleanID(e.id));
        delete idsMetadata[this.cleanID(e.id)]; 
        
            toDelete.push(e);
       
    } 


    function getChildren(parent){
        if (parent.id != null && parent.id != ""){ 
          
            local arr = [];
            foreach(i,name in parent.childLists ) {   
                local list = this.lists[this.names.find(name)];
                
                foreach (el in list) {
                    if (el.parents.find(parent.id) !=null){
                          
                        arr.push(el); 
                    }
                }
            }
         
            return arr;
        }
        return [];
    }
     function bSearch(list, index, low, high) {
        local idx = null;
      
        while( low <= high) {
            local mid = (low+high)/2;

            if (list[mid].metadata.index < index){
                low = mid + 1;
            } else if (list[mid].metadata.index > index ){
                high = mid - 1;
            } else if (list[mid].metadata.index == index ) { 
                idx = mid; 
                break; 
            } 
        }
        return idx;
       
    }

    function removeChildren(parent){
        if (parent.id != null && parent.id != ""){ 
            foreach(i,name in parent.childLists ) {   
                local list = this.lists[this.names.find(name)];
                local sizeBefore = list.len();
               
                local newList = list.filter(function(idx,e) {
                   
                   local UI = ::getroottable().UI;
                   local t = typeof e;
                    if (t == "instance"){
                        return true; 
                    }
                  
                    local isChildren =  e.parents.find(parent.id) != null;
                   
                    if (isChildren){ 
                       UI.addToDeleteQueue(e);
                       return false;
                    }
                    return true;
                }); 
                  local deleted = sizeBefore > newList.len();
                  
                  if (deleted) {
                      this.lists[this.names.find(name)] =  newList;
                  }
            }
        }
     
    }

    function findByID(id, list)    {
     
        if (id == null){
            return null;
        }
        foreach(i,e in list ) {
           if (e.id == id){
               return e;
           } 
        }
        return null; 
    }

   
    function findById(id) { 
        local newid = this.cleanID(id);
       
        local listName =this.idsMetadata[newid].list; 
        local list = this.lists[names.find(listName)];

        local idx = this.bSearch(list, idsMetadata[newid].index, 0, list.len()-1);
        if (idx == null){
            return null;
        }
        local e =  list[idx];
        
        return e;
    }

   
 
    function deleteByID(id,list, listName)    { 
       
        local sizeBefore = list.len(); 
        local newList = list.filter(function(idx,el) { 
            
            local foundGUIEl = id == el.id;
            local foundInstance = (typeof el == "instance"  && el.id == id);
            if (foundGUIEl || foundInstance){

                if (foundGUIEl) {
                    el.Detach(); 
                }
                ::getroottable().UI.addToDeleteQueue(el);
                return false;
            }
            return true;
        });
        local deleted = sizeBefore > newList.len();
       
        if (deleted){
            return newList ;
        } 
        return null; 
          
    }


    function registerKeyBind(o){
        foreach(i,kp in kps ) {
            if (kp.name == o.name){
                o.kp = null;
                return;
            }
        }        
        kps.push(o);
    }

    function deleteKeybind(name) {
        local idx = null;
        foreach(i,kp in kps ) {
            if (kp.name == name){
                kp.kp  = null;
                idx = i;
                break;
            }
        }
        if (idx !=null){
            kps.remove(idx);
        }        
    }

   
 
    function showTooltip(el){
        if (el.rawin("tooltip") && el.tooltip != null){
            if (el.tooltipVisible == null) {
                el.tooltipVisible = false;
            } 
            if (!el.tooltipVisible) {
                local mousePos =GUI.GetMousePos(); 

              
                if (mousePos != null) { 
                    local l = null ;
                      local pos =null; 
                    if (typeof el.tooltip == "string"){
                        l = UI.Label({id = el.id+"::tooltip::label",  Alpha = 200, move = { down = 2}, Text = el.tooltip, TextColour  = Colour(255,255,255,0) });
                       pos =  VectorScreen(GUI.GetMousePos().X -l.Size.X+15, GUI.GetMousePos().Y-50);
                    }else{
                         
                        l = UI.Label(el.tooltip.label);
                        if (el.tooltip.rawin("direction")) {
                            local dir = el.tooltip.direction;
                            if (dir == "up"){
                                pos = VectorScreen(GUI.GetMousePos().X -l.Size.X+15, GUI.GetMousePos().Y-50);
                            } else if (dir == "down"){
                                pos =VectorScreen(GUI.GetMousePos().X-l.Size.X+15, GUI.GetMousePos().Y+10);
                            }  else if (dir == "right"){
                                pos = VectorScreen(GUI.GetMousePos().X+20, GUI.GetMousePos().Y-l.Size.Y/2);
                            } else if (dir == "left"){
                                pos = VectorScreen(GUI.GetMousePos().X-l.Size.X-20, GUI.GetMousePos().Y-l.Size.Y/2);
                            }
                        }
                    }  


                    UI.Canvas({ 
                        id = el.id+"::tooltip",
                        Size = VectorScreen(l.Size.X+8, l.Size.Y+8),
                        Color= el.tooltip.rawin("canvasColor") ?  el.tooltip.canvasColor : Colour(0,0,0,150) ,  
                        Position = pos,
                        children = [l]
                       
                    });
                    el.tooltipVisible = true;
                }
            } 
        }    
    } 
 
  
    function findByPreset(name) {
        local els = [];
       
        foreach(i,list in lists ) { 
           foreach(c,e in list ) { 
                if (e.presets != null && e.presets.find(name) !=null) {
                    els.push(e);
                }
            }
        }
        return els; 
    } 

    function cleanID(id) {
        local newid = "";
        try {
        foreach (i, p in split(id, "::")) {
            if (p !=""){
                newid +=p;
            }
        }
        } catch(ex){
           // Console.Print(id+"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        }
        return newid;
    }


    function DeleteByID(id){
       local e = this.findById(id); 
       if (e != null ) {
           
           e.removeChildren();
       }
       local listName =this.idsMetadata[this.cleanID(id)].list;
       local list = this.lists[names.find(listName)]; 
        
        local newList =  this.deleteByID(id, list, listName); 
        if (newList != null){
            this.lists[names.find(listName)] = newList;
        }  
         
    } 
 

    function mergeArray(firstArray, newElement) {
        local arr = [];
        foreach (idx, e in firstArray) {
            if (e != null){
                arr.push(e); 
            }
        }   
        arr.push(newElement);
        return arr;
    }

   function print(msg) {
       if (debug){
           Console.Print(msg);
       }
       
   }

  
    function idIsValid(obj){
        if (obj.rawin("id")){
            if (obj.id == null){  
                return false; 
            }
            return !this.idsMetadata.rawin(this.cleanID(obj.id));
           
        }
        return false;
    }
 
    function idExists(id){
        return this.idsMetadata.rawin(this.cleanID(id));
    }

    function applyElementProps(element, obj){   
         // print("applyElementProps --->"+ obj.id);
        if (obj != null) { 
            if (!obj.rawin("id") || obj.id == null){    
                obj["id"] <- Script.GetTicks() + typeof element;
            }
            element.UI = ::getroottable().UI; 
            if (this.idIsValid(obj)){  
                foreach(i,e in obj ) {
                    try {  
                        if (i == "flags"){
                            element.AddFlags(obj[i]);
                           
                        } else if (i == "fontFlags"){
                            element.FontFlags = obj[i];
                        } else {
                            element[i] =obj[i]; 
                        }
                    } catch (e){
                       // print(e);
                    }
                }
                if (element.rawin("contextMenu") || element.rawin("tooltip")) {
                    element.AddFlags(GUI_FLAG_MOUSECTRL);
                }
                this.align(element);  
                this.shift(element);
                
            }else{
                //print("ID NOT VALID "+ obj.id);
          
                //print("canvas --> "+ this.lists[this.names.find("canvas")].len());
            }
        }

       return element;
    }  

    function Delete(e) { 
        local t = typeof e; 
        
        this.DeleteByID(e.id);
      
    } 
     
    function Button(o){ 
        if (typeof o == "string") {
            return this.fetch.button(o);
        }        
       
        local b = this.applyElementProps(GUIButton(), o);
        b.metadata = { list = "buttons" , index = this.listsNumeration.buttons  };
        if ( !o.rawin("Size") ){ 
            b.Size = VectorScreen(50,25);
        }
       
        lists[names.find("buttons")].push(b); 
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list , index = this.listsNumeration.buttons };
        this.listsNumeration.buttons++;

        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }
       // print(b.id +" created");
        return b; 
    } 

  

    function ComboBox(o){  
        if (typeof o == "string") {
            local combo = this.fetch.canvas(o);
            if (combo != null) {
                return combo.context;
            } else{
                return null;
            }
        }         
        local c = Combobox(o);
        c.metadata.list ="comboboxes";
        c.metadata.index = this.listsNumeration.comboboxes; 

        lists[names.find("comboboxes")].push(c); 

         if (c.rawin("postConstruct")){
            if (c.postConstruct !=  null){
                c.postConstruct();
            }
        }
      
        this.listsNumeration.comboboxes++;
        return c;
    }

     function Popup(o){   
        if (typeof o == "string") {
            local p = this.fetch.canvas(o);
            if (p != null) {
                return p.context;
            } else{
                return null;
            }
        }         
        local c = PopUp(o);
        c.metadata.list ="popups";
        c.metadata.index = this.listsNumeration.popups;

        lists[names.find("popups")].push(c); 

        if (c.rawin("postConstruct")){
            if (c.postConstruct !=  null){
                c.postConstruct();
            }
        }
    
         this.listsNumeration.popups++;


        return c;
    }
     function DataTable(o){   
        if (typeof o == "string") {
            local p = this.fetch.canvas(o);
            if (p != null) {
                return p.context;
            } else{
                return null;
            }
        }         
        local c = Table(o);
        c.metadata.list ="datatables";
        c.metadata.index = this.listsNumeration.datatables;

        if (c.rawin("postConstruct")){
            if (c.postConstruct !=  null){
                c.postConstruct();
            }
        }

        this.listsNumeration.datatables++;  
        return c;
    }
    function TabView(o){   
        if (typeof o == "string") {
            local p = this.fetch.canvas(o);
            if (p != null) {
                return p.context;
            }else{
                return null;
            }
        }         
        local c = Tabview(o);
        c.metadata.list ="tabviews";
        c.metadata.index = this.listsNumeration.tabviews;

        lists[names.find("tabviews")].push(c); 
        this.listsNumeration.tabviews++; 
        if (c.rawin("postConstruct")){
            if (c.postConstruct !=  null){
                c.postConstruct();
            }
        }

        return c;
    }


    function Label(o){ 
        if (typeof o == "string") { 
            return this.fetch.label(o); 
        }

        if (!o.rawin("metadata")){
            o["metadata"] <-  { labelConstructor = "flags" } ;
        }else{
            o.metadata["labelConstructor"] <- "flags";
        }           
        local l = o.metadata.labelConstructor == "flags" ? GUILabel(VectorScreen(0,0), Colour(0,0,0), "", 0): GUILabel();
        local b = this.applyElementProps(l,o );
         b.metadata = { list = "labels", index = this.listsNumeration.labels   };

         lists[names.find("labels")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { 
            list = b.metadata.list,
            index = this.listsNumeration.labels
         };
        this.listsNumeration.labels++;

        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }

        return b;
    }
     function Editbox(o){
        if (typeof o == "string") {
            return this.fetch.editbox(o);
        }           
        local b = this.applyElementProps(GUIEditbox(VectorScreen(0,0), VectorScreen(0,0), Colour(255,255,255)), o);
        b.metadata = { list = "editboxes", index = this.listsNumeration.editboxes   };

        lists[names.find("editboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { 
            list = b.metadata.list,
            index = this.listsNumeration.editboxes
        }; 
         this.listsNumeration.editboxes++;

         
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }

        return b;
    } 
     function Canvas(o){
        if (typeof o == "string") {
            return this.fetch.canvas(o);
        }
        
        local b = this.applyElementProps(GUICanvas(), o);
        b.metadata = { list = "canvas", index = this.listsNumeration.canvas   };
        if (o.rawin("children")  && o.children != null){
            foreach (i, c in o.children) {
                if (c.rawin("className")){
                    local className = c.className;
 
                    if (className == "GroupRow"){
                       c.index = i;
                       b.add(c.build(b));
                    } else if (className == "Combobox"){
                        c.attachParent(b);
                    } 

                }else {
                    b.add(c);
                  
                }
            }
        }
       
         lists[names.find("canvas")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { 
            list = b.metadata.list,
            index = this.listsNumeration.canvas
         };

         if (o.rawin("children")  && o.children != null){
            foreach (i, c in o.children) {
                 if (!c.rawin("className")) {
                    c.realign();
                    c.shiftPos();
                }
            }
        }
        this.listsNumeration.canvas++;
        
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }
        return b;
    }
    function Checkbox(o){
        if (typeof o == "string") {
            return this.fetch.checkbox(o);
        }          
        local b = this.applyElementProps(GUICheckbox(), o);
        b.metadata = { list = "checkboxes" , index = this.listsNumeration.checkboxes  };
        lists[names.find("checkboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.checkboxes };
        this.listsNumeration.checkboxes++;
        return b; 
    }
      function Listbox(o){
        if (typeof o == "string") {
            return this.fetch.listbox(o);
        }           
        local b = this.applyElementProps(GUIListbox(), o);
        b.metadata = { list = "listboxes" , index = this.listsNumeration.listboxes    };

        if (o.rawin("options") && o.options != null) {
            foreach (i,item in o.options) {
                b.AddItem(item);
            }
        }
        
         lists[names.find("listboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.listboxes };
        this.listsNumeration.listboxes++;
        
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }
        return b;
    }
      function Memobox(o){
        if (typeof o == "string") {
            return this.fetch.memobox(o);
        }          
        local b = this.applyElementProps(GUIMemobox(), o);
        b.metadata = { list = "memoboxes" , index = this.listsNumeration.memoboxes  };
        lists[names.find("memoboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.memoboxes };
        this.listsNumeration.memoboxes++;
        return b;
    }
       function ProgressBar(o){ 
        if (typeof o == "string") {
            return this.fetch.progressBar(o);
        }           
        local b = this.applyElementProps(GUIProgressBar(), o);
         b.metadata = { list = "progbars" , index = this.listsNumeration.progbars   };
        lists[names.find("progbars")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.progbars };
        this.listsNumeration.progbars++;

        
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }
        return b;
    }
       function Scrollbar(o){
        if (typeof o == "string") {
            return this.fetch.scrollbar(o);
        } 
        local b = this.applyElementProps(GUIScrollbar(), o);
        b.metadata = { list = "scrollbars", index = this.listsNumeration.scrollbars   };
         lists[names.find("scrollbars")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list,  index = this.listsNumeration.scrollbars };
        this.listsNumeration.scrollbars++;
        
        
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }

        return b; 
    }
    function Sprite(o){
        if (typeof o == "string") {
            return this.fetch.sprite(o);
        }
        local b = this.applyElementProps(GUISprite(), o);
        b.metadata = { list = "sprites", index = this.listsNumeration.sprites   };
        if (o.rawin("file")){  
            b.SetTexture(o.file);
        }
        
         lists[names.find("sprites")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list,  index = this.listsNumeration.sprites  };
        this.listsNumeration.sprites++;

        
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }

        return b;
    }
     function Window(o){
        if (typeof o == "string") {
            return this.fetch.window(o); 
        } 
        local b = this.applyElementProps(GUIWindow(), o);
        b.metadata = { list = "windows" , index = this.listsNumeration.windows   };
        if (o.rawin("children")  && o.children != null){
            foreach (i, c in o.children) {
                if (c.rawin("className")){
                    local className = c.className;

                    if (className == "GroupRow"){
                       c.index = i;
                       b.add(c.build(b));
                    }
 
                }else {
                    b.add(c);
                   
                }
            }
        }
      
       
        lists[names.find("windows")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list,  index = this.listsNumeration.windows };
         this.listsNumeration.windows++;

        if (o.rawin("children")  && o.children != null){
            foreach (i, c in o.children) {
                 if (!c.rawin("className")) {
                    c.realign();
                    c.shiftPos();
                }
            }
        }

        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }
        return b;
    }
   
}