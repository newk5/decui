class DecUI  {
    static version = "v1.2.0";
    toDelete=null;

    kps = null;
    res = null;

    hoveredEl=null;

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
    store = null;
    streamControllers = [];
    lastClickedEl = null;
    openNots = 0;
    notsHeight = 0;
    data = null;
    defaultTableProps = [ "data" ,"elementData", "metadata"];
    defaultBooleanProps = [ "autoResize" ,"delayWrap"];
    defaultArrayProps = [ "parents" ,"childLists", "presets"];
    showDebugInfo = false;
    excludeDebugIds =false;
    GLOBAL_COUNTER = 0;
    presets = {};

    constructor() {

        this.toDelete =[];
        this.kps  = [];
        idsMetadata = {};
        listsNumeration = {};

        lists = [ ];
        names = [ "labels", "buttons", "sprites", "windows", "progbars", "canvas", "scrollbars", "memoboxes", "editboxes", "listboxes" , "checkboxes"];
        foreach (idx, name in names) {
           listsNumeration[name] <- 0;
           lists.push([]);
        }

        this.fetch = Fetch(this);
        this.events = Events(this);

    }

    function registerComponent(name, obj) {
        this.lists.push([]);
        this.names.push(name);
        listsNumeration[name] <- 0;
        DecUI.rawset(name, function (o) {
            local isString = typeof o == "string";
            if (isString){
                return UI.findByID(o, UI.lists[UI.names.find(name)]);
            }

            local c = obj.create.call(::getroottable(),o);
            c.metadata.list =name;
            UI.addToListAndIncNumeration(c);
            c.resetMoves();

            c.shiftPos();
            UI.apply3DProps(o, c.getCanvas());
            UI.postConstruct(o);
            return c;
        });

    }


    function getList(name){
        return lists[names.find(name)];
    }

    function newData(key, value){
        if (this.store==null){
            this.store= Store({});

        }
        this.store.newData(key,value);
    }

    function Data(data) {
         this.store= Store(data);
    }
    function Subscribe(key, obj ={ }) {
        if (!obj.rawin("onChange")){
            obj["onChange"] <- null;
        }
        if (!obj.rawin("onPush")){
            obj["onPush"] <- null;
        }
        if (!obj.rawin("onChange")){
            obj["onChange"] <- null;
        }
        if (!obj.rawin("onPop")){
            obj["onPop"] <- null;
        }
        if (!obj.rawin("onDecrement")){
            obj["onDecrement"] <- null;
        }
        if (!obj.rawin("onIncrement")){
            obj["onIncrement"] <- null;
        }

        this.store.sub(key, obj);
    }

    function processStream(streamIdentifier, stream){
        foreach(i, sc in this.streamControllers) {

            if (streamIdentifier == sc.identifier) {

                sc.readResponse(stream);
                break;
            }
        }
    }

    function removeStream(streamIdentifier){
         foreach(i, sc in this.streamControllers) {

            if (streamIdentifier == sc.identifier) {

                streamControllers.remove(i);

            }
        }
    }


    function removeBorders(e){
        if (e.rawin("data") && e.data != null && e.data.rawin("borderIDs") && e.data.borderIDs != null){
            e.data.borderIDs.clear();

            foreach (idx, c in this.lists[this.names.find("canvas")]) {
                if (c.parents.find(e.id) != null && c.rawin("data") && c.data.rawin("isBorder") && c.data.isBorder != null && c.data.isBorder){
                    c.destroy();
                }

            }
        }
    }

     function updateBorders(e){
        foreach (idx, c in this.lists[this.names.find("canvas")]) {
            if (c.parents.find(e.id) != null && c.rawin("data") && c.data.rawin("isBorder") && c.data.isBorder != null && c.data.isBorder){

                if (c.id.find("top_center") != null || c.id.find("bottom_left") != null) {
                    c.Size.X = e.Size.X;
                }else{
                     c.Size.Y = e.Size.Y;
                }

                c.realign();
            }

        }
    }

    function hasAllBorders(e){
        return e.rawin("data") && e.data != null && e.data.rawin("borderIDs") && e.data.borderIDs != null && e.data.borderIDs.len()==4;
    }

    function addBorder(e, b, align) {
        if (this.hasAllBorders(e)){
            return;
        }
        local id = e.id == null ? Script.GetTicks() : e.id;
        local size = null;
        local borderPos = null;
        local parentsList =   e.id == null ? e.parents : mergeArray(e.parents, e.id);
        local move = {};
        local offset = b.rawin("offset") ? b.offset:0;


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
                data = { isBorder = true, borderPos = borderPos, offset = offset},
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


        e.add(border, false);
       // border.realign();
        //border.shiftPos();
    }

    function applyRelativeSize(e) {
        local hasRelativeSize = e != null && e.rawin("RelativeSize") && e.RelativeSize != null && e.RelativeSize.len() > 0;
        if (!hasRelativeSize) {
            return;
        }
        local w = (this.removePercent(e.RelativeSize[0]).tofloat() / 100).tofloat();
        local h = (this.removePercent(e.RelativeSize[1]).tofloat() / 100).tofloat();

        local wrapper = null;

        if (e.parents.len() == 0){
            wrapper = GUI.GetScreenSize();
        }else{

            local lastID = e.parents[e.parents.len()-1];

            local parent = findById(lastID);

            wrapper =  parent == null ? GUI.GetScreenSize() : parent.Size;
        }

        e.Size.X = (w*wrapper.X);
        e.Size.Y = (h*wrapper.Y);
        e.updateBorders();

    }

    function align(e) {
        if (e.align != null){
            local a = e.align.tolower();
            local t = typeof e;
            local isLabel = t == "GUILabel";
            local paddingX =11;
            local paddingY =5;
            local sizeX = isLabel ? e.TextSize.X+paddingX : e.Size.X;
            local sizeY = isLabel ? e.TextSize.Y+paddingY : e.Size.Y;
            local wrapper = null;
            local offset = 0;
            local parent = null;

             if (e.rawin("data") && e.data.rawin("offset")){
                offset = e.data.offset;
            }
            if (e.parents.len() == 0){
                wrapper = GUI.GetScreenSize();
            }else{

                local lastID = e.parents[e.parents.len()-1];
                parent = findById(lastID);
               
                wrapper =  parent == null ? GUI.GetScreenSize() : parent.Size;
            }
           
            

            if (a == "top_right"){

                e.Position.Y = 0;
                e.Position.X = wrapper.X - sizeX;
                e.Position.X += offset;

            } else if (a == "top_left"){
                e.Position.Y = 0;
                e.Position.X = 0;
                e.Position.X -= offset;
            } else if (a == "top_center"){
                e.Position.Y = 0;
                e.Position.X = wrapper.X / 2 - sizeX /2;
                e.Position.Y -= offset;
            } else if (a == "bottom_right"){
                e.Position.Y = wrapper.Y - sizeY;
                e.Position.X = wrapper.X - sizeX;

            } else if (a == "bottom_left"){
                e.Position.Y =  wrapper.Y - sizeY;
                e.Position.X = 0;
                 e.Position.Y += offset;
            } else if (a == "bottom_center" || a == "bottom"){
                e.Position.Y = wrapper.Y - sizeY;
                e.Position.X = wrapper.X / 2 - sizeX /2;
            } else if (a == "mid_center" || a == "center"){
                e.Position.Y = wrapper.Y / 2 - sizeY /2;
                e.Position.X = wrapper.X / 2 - sizeX /2;
           } else if (a == "mid_left"){
                e.Position.Y = wrapper.Y / 2 - sizeY /2;
                e.Position.X = 0;
            } else if (a == "mid_right"){
                e.Position.Y = wrapper.Y / 2 - sizeY /2;
                e.Position.X = wrapper.X - sizeX;
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
                e.Position.X = wrapper.X - (wrapper.X /20);
            }

            //avoid positioning off bounds
            if (e.Position.Y < 0){
                e.Position.Y = 0;
            }
            if (e.Position.X < 0){
                e.Position.X = 0;
            }

        }

    }

    function shift(e){
        if (e.move != null){
            local s = e.move;
            local previousPosition = VectorScreen(e.Position.X, e.Position.Y);
            e.metadata["previousPosition"] <- previousPosition;
            if(typeof s  != "function"){
                if (s != null && s.rawin("left")){
                    local isString = typeof s.left == "string";
                    if (isString){

                        local wrapper =  e.getWrapper();
                        if (!e.metadata.rawin("movedPos")){
                           e.metadata["movedPos"] <- [];
                        }
                        if (e.metadata.movedPos.find("left") != null){
                            return;
                        } else{
                            e.metadata.movedPos.push("left");
                            local percent = this.removePercent(s.left).tofloat();
                            e.Position.X -= ( wrapper.X * percent / 100 ).tofloat();

                        }


                        if (e.metadata.movedPos.len() == 0){
                           e.realign();
                        }


                    }else{
                        e.Position.X =  e.Position.X - s.left;
                    }
                }
                if (s.rawin("right")){

                    local isString = typeof s.right == "string";
                     if (isString){

                        local wrapper =  e.getWrapper();
                         if (!e.metadata.rawin("movedPos")){
                            e.metadata["movedPos"] <- [];
                        }
                        if (e.metadata.movedPos.find("right") != null){
                            return;
                        }else{
                            e.metadata.movedPos.push("right");
                            local percent = this.removePercent(s.right).tofloat();
                            e.Position.X += ( wrapper.X * percent / 100 ).tofloat();

                        }

                         if (e.metadata.movedPos.len() == 0){
                            e.realign();
                        }


                    } else {
                        e.Position.X =  e.Position.X + s.right;
                    }
                }
                if (s.rawin("up")){
                    local isString = typeof s.up == "string";
                    if (isString){
                         local wrapper = e.getWrapper();
                         if (!e.metadata.rawin("movedPos")){
                           e.metadata["movedPos"] <- [];
                        }
                        if (e.metadata.movedPos.find("up") != null){
                            return;
                        }else{
                            e.metadata.movedPos.push("up");
                            local percent = this.removePercent(s.up).tofloat();
                            e.Position.Y -= ( wrapper.Y * percent / 100 ).tofloat();
                        }

                        if (e.metadata.movedPos.len() == 0){
                            e.realign();
                        }


                    } else {
                        e.Position.Y =  e.Position.Y - s.up;
                    }
                }
                if (s.rawin("down")){
                    local isString = typeof s.down == "string";

                     if (isString){
                        local wrapper =  e.getWrapper();
                         if (!e.metadata.rawin("movedPos")){
                           e.metadata["movedPos"] <- [];
                        }
                        if (e.metadata.movedPos.find("down") != null){
                            return;
                        } else{
                            e.metadata.movedPos.push("down");
                            local percent = (this.removePercent(s.down).tofloat() / 100).tofloat();
                            e.Position.Y += ( wrapper.Y * percent ).tofloat();
                        }

                        if (e.metadata.movedPos.len() == 0){
                            e.realign();
                        }



                    } else {
                        e.Position.Y =  e.Position.Y + s.down;
                    }
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
        local id= this.cleanID(e.id);
        if (idsMetadata.rawin(id)){
            delete idsMetadata[id];
            //e = null;
            toDelete.push(e);
        }


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

    function removeChildren(parent, toBeRemoved){
        if (parent.id != null && parent.id != ""){
            foreach(i,name in parent.childLists ) {
                local listIdx = this.names.find(name);
                local list = this.lists[listIdx];

                foreach(idx, e in list) {
                    local UI = ::getroottable().UI;
                    local t = typeof e;

                    if (t == "instance"){
                        continue;
                    }

                    local isChildren =  e.parents.find(parent.id) != null;

                    if (isChildren){
                        e.removeChildren(true, toBeRemoved);
                        UI.addToDeleteQueue(e);
                        toBeRemoved.rawin(listIdx) ?
                            (toBeRemoved[listIdx].find(idx) == null ? toBeRemoved[listIdx].push(idx) : null) :
                            toBeRemoved.rawset(listIdx, [idx]);
                    }
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
        try {
            local listName =this.idsMetadata[newid].list;

            local list = this.lists[names.find(listName)];

            local idx = this.bSearch(list, idsMetadata[newid].index, 0, list.len()-1);

            if (idx == null){
                return null;
            }
            local e =  list[idx];
           return e;


        }catch (ex){
           // Console.Print(ex);
           //Console.Print("FAILED TO FIND "+newid);
            return null;
        }
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
                local col = null;

                local x = el.Position.X;
                local y = el.Position.Y;
                 local initialPos = VectorScreen(x,y);

                if (el.hasParents()){

                      local parent = UI.Canvas(el.getFirstParent());

                    el.Detach();
                    x = el.Position.X;
                    y = el.Position.Y;

                    if (parent == null){
                        parent = UI.Window(el.getFirstParent());
                    }


                    parent.AddChild(el);
                    el.Position = initialPos;


                }

                if (mousePos != null) {

                    local l = null ;
                    local pos =null;
                    if (typeof el.tooltip == "string"){
                        col = Colour(0,0,0,150);
                        local exists = idExists(el.id+"::tooltip::label");
                        if (exists){
                             l = UI.Label(el.id+"::tooltip::label");
                        } else {
                            l = UI.Label({id = el.id+"::tooltip::label", align="center" Alpha = 200,  Text = el.tooltip, TextColour  = Colour(255,255,255,0) });
                        }
                        y -= el.Size.Y+10;
                    }else{
                         col = el.tooltip.rawin("canvasColor") ? el.tooltip.canvasColor : Colour(0,0,0,150);
                        if (el.tooltip.rawin("label")){
                            l = UI.Label(el.tooltip.label);
                            if (el.tooltip.rawin("direction")) {
                                local dir = el.tooltip.direction;
                                if (dir == "up"){
                                    y -= el.Size.Y+10;

                                } else if (dir == "down"){
                                    y +=el.Size.Y+10;

                                }  else if (dir == "right"){
                                    x += el.Size.X+10;

                                } else if (dir == "left"){
                                    x -= el.Size.X-10;

                                }
                            }
                        }
                    }
                      pos =  VectorScreen(x, y);
                    local c = null;
                    if (idExists(el.id+"::tooltip")){
                       c = UI.Canvas(el.id+"::tooltip");
                    }else {
                        c = UI.Canvas({
                            id = el.id+"::tooltip",
                            Size = el.tooltip.rawin("Size") ? el.tooltip.Size : VectorScreen(l.Size.X+8, l.Size.Y+8),
                            Color= col
                            Position = pos
                            autoResize = el.tooltip.rawin("Size") ? false: true
                        });
                    }


                    if (l != null){
                        c.add(l, false);
                    }
                     el.tooltipVisible = true;

                    if (el.tooltip.rawin("extraLabels")){
                        local addY=0;
                        foreach(i,ce in el.tooltip.extraLabels ) {
                            local cid = Script.GetTicks()+""+i;
                            ce["id"] <- cid;
                            local exl =UI.Label(ce);
                            c.add(exl, false);
                            addY += exl.TextSize.Y;
                        }
                        c.Size.Y += addY;
                    }

                    if (el.tooltip.rawin("border")){
                        c.addBorders(el.tooltip.border);
                    }




                }
            }
        }
    }


    function getPreset(name) {
        if (this.presets.rawin(name)){
            return this.presets[name];
        }
        return null;
    }

    function Preset(name, preset) {
        this.presets[name] <- preset;
    }

    function Presets(table) {
        foreach(key, value in table){
             this.Preset(key,value);
        }
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


        }
        return newid;
    }

    function removePercent(p){
        if (p.find("%") != null){
            return split(p, "%")[0];
        }
        return p;
    }



      function DeleteByID(id){
        local e = this.findById(id);
        if (e != null ) {
                e.removeChildren();
        }
        local newid = this.cleanID(id);
        if (this.idsMetadata.rawin(newid)) {

            local listName =this.idsMetadata[newid].list;
            local list = this.lists[names.find(listName)];

                local newList =  this.deleteByID(id, list, listName);
                if (newList != null){
                    this.lists[names.find(listName)] = newList;
                }
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
            local exists = idExists(obj.id);
            if (exists){
                Console.Print("[ERROR] ----> "+obj.id +" already exists!");
            }
            return !exists;

        }
        return false;
    }

    function idExists(id){
        try {
            return this.idsMetadata.rawin(this.cleanID(id));
        } catch (e){

        }

    }
    function applyPreset(element, obj) {
         //add flags first to prevent crash with  GUI_FLAG_TEXT_TAGS
         if (obj.rawin("flags")){
            element.AddFlags(obj.flags);
        }
        //set text first to prevent mgui bug with .Text reseting font size
         if (obj.rawin("Text")){
            element.Text = obj.Text;
        }
        foreach(i,e in obj ) {
            try {

                if (i != "flags" && i != "Flags" && i != "Text"){
                    if (i == "fontFlags"){
                        element.FontFlags = obj[i];
                    } else {
                        element[i] =obj[i];
                    }

                }
            } catch (e){


            }
        }
        if (element.rawin("contextMenu") || element.rawin("tooltip")) {
            element.AddFlags(GUI_FLAG_MOUSECTRL);
        }
         if (obj.rawin("RelativeSize")){
            this.applyRelativeSize(element);
        }
        
      
        if (obj.rawin("RemoveFlags") && obj.RemoveFlags != null){
            element.RemoveFlags(obj.RemoveFlags);
        }
        element.rePosition();

    }

    function applyElementProps(element, obj){


        if (obj != null) {
            if (!obj.rawin("id") || obj.id == null){
                obj["id"] <- Script.GetTicks() + typeof element+":"+ UI.GLOBAL_COUNTER;
                UI.GLOBAL_COUNTER++;
            }
            
            element.UI = ::getroottable().UI;
            if (this.idIsValid(obj)){
                foreach (prop in this.defaultTableProps) {
                    element[prop] =  {};
                }
                foreach (prop in this.defaultBooleanProps) {
                    element[prop] =  false;
                }
                foreach (prop in this.defaultArrayProps) {
                    element[prop] =  [];
                }


                if (obj.rawin("presets") && obj.presets != null){
                    foreach(preset in obj.presets){
                        local presetTable = this.getPreset(preset);
                        if (presetTable != null){
                            this.applyPreset(element, presetTable);
                            if (obj.rawin("onPresetAdded") && obj.onPresetAdded != null){
                                obj.onPresetAdded(preset);
                            }
                        }
                       
                    }
                }

                //add flags first to prevent crash with  GUI_FLAG_TEXT_TAGS
                if (obj.rawin("flags")){
                    element.AddFlags(obj.flags);
                }
                //set text first to prevent mgui bug with .Text reseting font size
                 if (obj.rawin("Text")){
                    element.Text = obj.Text;
                }
                foreach(i,e in obj ) {
                    try {

                        if (i != "flags" && i != "Flags" && i != "Text"){
                            if (i == "fontFlags"){
                                element.FontFlags = obj[i];
                            } else {
                                element[i] =obj[i];
                            }

                        }
                    } catch (e){


                    }
                }
                if (element.rawin("contextMenu") || element.rawin("tooltip")) {
                    element.AddFlags(GUI_FLAG_MOUSECTRL);
                }
                 if (obj.rawin("RelativeSize")){
                    this.applyRelativeSize(element);
                }
                  element.metadata = {
                    ORIGINAL_POS = VectorScreen(element.Position.X, element.Position.Y)
                    list = ""
                    index = null
                    originalObject = null
                };


                this.align(element);
                
                this.shift(element);
                
                if (obj.rawin("RemoveFlags") && obj.RemoveFlags != null){
                    element.RemoveFlags(obj.RemoveFlags);
                }

            }else{
                //Console.Print("ID NOT VALID "+ obj.id);


            }
        }

       return element;
    }

    function Delete(e) {
        local t = typeof e;

        this.DeleteByID(e.id);

    }

    function postConstruct(b){
        if (b.rawin("postConstruct")){
            if (b.postConstruct !=  null){
                b.postConstruct();
            }
        }
    }

    function Button(o){
        if (typeof o == "string") {
            return this.fetch.button(o);
        }

        local b = this.applyElementProps(GUIButton(), o);
        b.metadata.list = "buttons";
        b.metadata.index = this.listsNumeration.buttons;

        if ( !o.rawin("Size") ){

            b.Size = VectorScreen(50,25);
        }

        lists[names.find("buttons")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list , index = this.listsNumeration.buttons };
        this.listsNumeration.buttons++;
         if (o.rawin("bindTo")){
            this.store.attachIDAndType(o.bindTo,o.id, "GUIButton");
            local val = this.store.get(o.bindTo);
            b.Text = val;
        }
        if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
        if (o.rawin("border") ){
            this.applyBorder(o.border, b);
        }
        this.postConstruct(b);
        this.apply3DProps(o,b);
        debug(b);
        return b;
    }

    function debug(b){
         if (showDebugInfo){
            if (!this.excludeDebugIds){
                UI.incData(b.metadata.list);
            }else if (b.id.find("decui:debug")==null){
                UI.incData(b.metadata.list);
            }

        }
    }

    function addToListAndIncNumeration(c){

        local list = c.metadata.list;
        c.metadata.index = this.listsNumeration[list];
        lists[names.find(list)].push(c);

        this.listsNumeration[list]++;
         if (showDebugInfo){
             if (!excludeDebugIds){
                 UI.incData(list);
             }else if (c.id.find("decui:debug")==null) {
                  UI.incData(list);

             }

        }
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
        b.metadata.list = "labels";

        b.metadata.index = this.listsNumeration.labels;
        b.metadata.originalObject = o;
        b.metadata["lines"] <- [];
        b.metadata["originalText"] <- o.Text;

        lists[names.find("labels")].push(b);


        idsMetadata[this.cleanID(o.id)] <- {
            list = b.metadata.list,
            index = this.listsNumeration.labels
         };
        this.listsNumeration.labels++;
        b.shiftPos();
        this.postConstruct(b);

        if (o.rawin("bindTo")){
             this.store.attachIDAndType(o.bindTo,o.id, "GUILabel");
             b.setText(this.store.get(o.bindTo));
        }
        if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
       
         this.apply3DProps(o,b);
        debug(b);


        return b;
    }
     function Editbox(o){
        if (typeof o == "string") {
            return this.fetch.editbox(o);
        }
        local b = this.applyElementProps(GUIEditbox(VectorScreen(0,0), VectorScreen(0,0), Colour(255,255,255)), o);
        b.metadata.list = "editboxes";
        b.metadata.index = this.listsNumeration.editboxes;

        lists[names.find("editboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- {
            list = b.metadata.list,
            index = this.listsNumeration.editboxes
        };
         this.listsNumeration.editboxes++;


        this.postConstruct(b);
        if (o.rawin("bindTo")){
             this.store.attachIDAndType(o.bindTo,o.id, "GUIEditbox");
             b.Text = this.store.get(o.bindTo);
        }
         if (b.getParent() == null){
             b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
         this.apply3DProps(o,b);
        debug(b);
        return b;
    }

    function pushData(key, value, dataUpdateOnly=false) {
        this.setData(key, value, "push", dataUpdateOnly);
    }
     function popData(key, value = 0, dataUpdateOnly=false) {
        this.setData(key, value, "pop", dataUpdateOnly);
    }

    function incData(key, value = 1, dataUpdateOnly=false) {
        this.setData(key, value, "inc", dataUpdateOnly);
    }

    function decData(key, value = 1, dataUpdateOnly=false) {
        this.setData(key, value, "dec", dataUpdateOnly);
    }

    function setData(key,val, op = "set", dataUpdateOnly=false){
        if (this.store == null){
            this.store = Store({});
        }
        this.store.set(key,val,op, dataUpdateOnly);
    }

    function indexOfData(key, item) {
        local arr = this.store.get(key);
        local t = typeof arr;
        if (arr != null && t == "array"){
            return arr.find(item);
        }
    }

    function eachData(key,callback) {
        local arr = this.store.get(key);
        local t = typeof arr;
        if (arr != null && t == "array"){
            foreach (item in arr) {
                callback(item);
            }
        }
    }

    function Focus(e) {
        GUI.SetFocusedElement(e);
    }

     function Unfocus() {
        GUI.SetFocusedElement(null);
    }

    function getData(key){
        return this.store.get(key);
    }

    function applyBorder(b,e) {
        if (b != null){
            local hasLeft = b.rawin("left");
            local hasRight = b.rawin("right");
            local hasTop = b.rawin("top");
            local hasBottom = b.rawin("bottom");
            if (b.rawin("left")) {
                e.addLeftBorder(b.left);
            }
            if (b.rawin("right")) {
                e.addRightBorder(b.right);
            }
            if (b.rawin("top")) {
                e.addTopBorder(b.top);
            }
            if (b.rawin("bottom")) {
                e.addBottomBorder(b.bottom);
            }
            if (!hasLeft && !hasRight && !hasTop && !hasBottom ){
                e.addBorders(b);
            }
        }
    }

     function Canvas(o){
        if (typeof o == "string") {
            return this.fetch.canvas(o);
        }


        local b = this.applyElementProps(GUICanvas(), o);

        b.metadata.list = "canvas";
        b.metadata.index = this.listsNumeration.canvas;
        lists[names.find("canvas")].push(b);
        idsMetadata[this.cleanID(o.id)] <- {
            list = b.metadata.list,
            index = this.listsNumeration.canvas
        };

        this.listsNumeration.canvas++;

        if (o.rawin("children")  && o.children != null){
            foreach (i, child in o.children) {
                b.add(child, false);
                /*
                .add() already postions, aligns and moves the child, however,
                at that point the child has already gone through those stages
                once when it was created, and at that point the parent didn't exist yet
                which means all of those stages were done with values relative to the player resolution
                so we must reset the position and go through these same stages once again
                */
                child.rePosition();
            }
        }


        if (b.autoResize){
            b.realign();
            b.resetMoves();
            b.shiftPos();
        }
      
        if (o.rawin("border") ){
            this.applyBorder(o.border, b);
        }
        this.apply3DProps(o,b);
        this.postConstruct(b);
        debug(b);
        return b;
    }
    function Checkbox(o){
        if (typeof o == "string") {
            return this.fetch.checkbox(o);
        }
        local b = this.applyElementProps(GUICheckbox(), o);
        b.metadata.list = "checkboxes";
        b.metadata.index = this.listsNumeration.checkboxes;
        lists[names.find("checkboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.checkboxes };
        this.listsNumeration.checkboxes++;

         this.postConstruct(b);

          if (o.rawin("bindTo")){
             this.store.attachIDAndType(o.bindTo,o.id, "GUICheckbox");
            local val = this.store.get(o.bindTo);
            if (val){
                b.AddFlags(GUI_FLAG_CHECKBOX_CHECKED);
            }else{
                 b.RemoveFlags(GUI_FLAG_CHECKBOX_CHECKED);
            }
        }
        if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
         this.apply3DProps(o,b);
        debug(b);
        return b;
    }
      function Listbox(o){
        if (typeof o == "string") {
            return this.fetch.listbox(o);
        }
        local b = this.applyElementProps(GUIListbox(), o);
        b.metadata.list = "listboxes";
        b.metadata.index = this.listsNumeration.listboxes;

        if (o.rawin("bindTo")){
            this.store.attachIDAndType(o.bindTo,o.id, "Listbox");
            local val = this.store.get(o.bindTo);
            o["options"] <- val;
        }
        if (o.rawin("options") && o.options != null) {

            foreach (i,item in o.options) {
                b.AddItem(item);
            }
        }

         lists[names.find("listboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.listboxes };
        this.listsNumeration.listboxes++;

        this.postConstruct(b);
        if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
         this.apply3DProps(o,b);
        debug(b);
        return b;
    }
      function Memobox(o){
        if (typeof o == "string") {
            return this.fetch.memobox(o);
        }
        local b = this.applyElementProps(GUIMemobox(), o);
        if (o.rawin("bindTo")){
            this.store.attachIDAndType(o.bindTo,o.id, "GUIMemobox");
            local val = this.store.get(o.bindTo);
            foreach (line in val) {
                b.AddLine(line)
            }
        }else if (o.rawin("lines")){
            foreach (line in o.lines) {
                b.AddLine(line)
            }
        }
        b.metadata.list = "memoboxes";
        b.metadata.index = this.listsNumeration.memoboxes;
        lists[names.find("memoboxes")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.memoboxes };
        this.listsNumeration.memoboxes++;

         this.postConstruct(b);
        if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
        this.apply3DProps(o,b);
        debug(b);
        return b;
    }
       function ProgressBar(o){
        if (typeof o == "string") {
            return this.fetch.progressBar(o);
        }
        local b = this.applyElementProps(GUIProgressBar(), o);
          b.metadata.list = "progbars";
        b.metadata.index = this.listsNumeration.progbars;


        lists[names.find("progbars")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list, index = this.listsNumeration.progbars };
        this.listsNumeration.progbars++;

        if (o.rawin("bindTo")){
            this.store.attachIDAndType(o.bindTo,o.id, "GUIProgressBar");
            local val = this.store.get(o.bindTo);
            b.Value = val;
        }

        if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
        this.apply3DProps(o,b);
        this.postConstruct(b);
        debug(b);

        return b;
    }
       function Scrollbar(o){
        if (typeof o == "string") {
            return this.fetch.scrollbar(o);
        }
        local b = this.applyElementProps(GUIScrollbar(), o);
         b.metadata.list = "scrollbars";
        b.metadata.index = this.listsNumeration.scrollbars;

         lists[names.find("scrollbars")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list,  index = this.listsNumeration.scrollbars };
        this.listsNumeration.scrollbars++;
           if (b.getParent() == null){
            b.metadata["posBeforeMove"] <- VectorScreen(b.Position.X,b.Position.Y);
        }
        b.shiftPos();
         this.apply3DProps(o,b);
        this.postConstruct(b);

       debug(b);

        return b;
    }
    function Sprite(o){
        if (typeof o == "string") {
            return this.fetch.sprite(o);
        }
        local s = o.rawin("file") ? GUISprite(o.file, o.rawin("Position") ? o.Position : VectorScreen(0,0 )) : GUISprite();
        local b = this.applyElementProps(s, o);

        b.metadata.list = "sprites";
        b.metadata.index = this.listsNumeration.sprites;
        if (o.rawin("file")){
            b.SetTexture(o.file);
        }

         lists[names.find("sprites")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list,  index = this.listsNumeration.sprites  };
        this.listsNumeration.sprites++;

        if (o.rawin("children")  && o.children != null){
            foreach (i, child in o.children) {
                 b.add(child, false);
                 child.rePosition();
            }
        }

         if (b.autoResize){
            b.realign();
            b.resetMoves();
            b.shiftPos();
        }
        if (o.rawin("border") ){
            this.applyBorder(o.border, b);
        }
        this.apply3DProps(o,b);
        this.postConstruct(b);
        debug(b);

        return b;
    }
     function Window(o){
        if (typeof o == "string") {
            return this.fetch.window(o);
        }
        local b = this.applyElementProps(GUIWindow(), o);

        b.metadata.list = "windows";
        b.metadata.index = this.listsNumeration.windows;

        lists[names.find("windows")].push(b);
        idsMetadata[this.cleanID(o.id)] <- { list = b.metadata.list,  index = this.listsNumeration.windows };
        this.listsNumeration.windows++;
          if (o.rawin("children")  && o.children != null){
            foreach (i, child in o.children) {
                b.add(child, false);
                child.rePosition();
            }
        }


         if (b.autoResize){
            b.realign();
            b.resetMoves();
            b.shiftPos();
        }


        this.apply3DProps(o,b);

        this.postConstruct(b);
        debug(b);
        return b;
    }

    function apply3DProps(o, element) {
         if (o.rawin("Transform3D")){

            element.AddFlags(GUI_FLAG_3D_ENTITY);

            local pos = o.Transform3D.rawin("Position3D") ? o.Transform3D.Position3D : Vector(0,0,0);
            local rot = o.Transform3D.rawin("Rotation3D") ? o.Transform3D.Rotation3D : Vector(-1.6, 0.0, 0);
            local size = o.Transform3D.rawin("Size3D") ? o.Transform3D.Size3D : Vector(2, 2, 0.0);
            element.Set3DTransform(pos, rot, size);
        }

    }

}