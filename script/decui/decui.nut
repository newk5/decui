dofile("decui/Timers.nut");
dofile("decui/UI/UI.nut");
dofile("decui/extensions.nut");


dofile("decui/UI/Fetch.nut");
dofile("decui/UI/Events.nut");

dofile("decui/UI/Store.nut");

dofile("decui/util/StreamRequest.nut");
dofile("decui/util/StreamReader.nut");


UI <- DecUI();

dofile("decui/components/DecUIComponent.nut");

dofile("decui/components/Combobox.nut");
dofile("decui/components/Sliders.nut");
dofile("decui/components/Pagination.nut");
dofile("decui/components/Popup.nut");
dofile("decui/components/Table.nut");
dofile("decui/components/Tabview.nut");
dofile("decui/components/Circle.nut");
dofile("decui/components/Notification.nut");
dofile("decui/components/Grid.nut");
dofile("decui/components/Menu.nut");
dofile("decui/components/SpriteSheet.nut");
dofile("decui/components/CanvasButton.nut");


function Script::ScriptProcess(){
    UI.events.scriptProcess();
}
function KeyBind::OnDown(keyBind) {
    UI.events.onKeyDown(keyBind);
}
function KeyBind::OnUp(keyBind) {
    UI.events.onKeyUp(keyBind);
}
function GUI::ElementClick(element, mouseX, mouseY){
    UI.events.onClick(element,mouseX,mouseY);
}
function GUI::ElementFocus(element){
    UI.events.onFocus(element);
}
function GUI::ElementBlur(element) {
    UI.events.onBlur(element);
}
function GUI::ElementHoverOver(element) {
    UI.events.onHoverOver(element);
}
function GUI::ElementHoverOut(element){
    UI.events.onHoverOut(element);
}
function GUI::ElementRelease(element, mouseX, mouseY){
    UI.events.onRelease(element, mouseX, mouseY);
}
function GUI::ElementDrag(element, mouseX, mouseY) {
    UI.events.onDrag(element, mouseX, mouseY);
}
function GUI::CheckboxToggle(checkbox, checked)  {
    UI.events.onCheckboxToggle(checkbox, checked);
}
function GUI::WindowClose(window) {
    UI.events.onWindowClose(window);
}
function GUI::InputReturn(editbox) {
    UI.events.onInputReturn(editbox);
}
function GUI::ListboxSelect(listbox, text) {
    UI.events.onListboxSelect(listbox,text);
}
function GUI::ScrollbarScroll(scrollbar, position, change) {
    UI.events.onScrollbarScroll(scrollbar, position,change);
}
function GUI::GameResize(width, height) {
   UI.events.onGameResize();

}
function GUI::WindowResize(window, width, height) {
    UI.events.onWindowResize(window, width, height);
}


UI.registerKeyBind({
    name= "left"+Script.GetTicks(),
    kp= KeyBind(0x01),
    onKeyUp = function() {

        if (UI.openContextID != null){
            local ctx =  UI.Canvas(UI.openContextID);
            if (ctx != null){
                if (ctx.rawin("onHide") && ctx.onHide != null){
                    ctx.onHide();
                }
                ctx.destroy();
                UI.openContextID= null;
                UI.hoveredEl=null;
            }

        }

    }
});

UI.registerKeyBind({
    name= "right"+Script.GetTicks(),
    kp= KeyBind(0x02),
    onKeyUp = function() {

       if (UI.hoveredEl != null ){
           local e = UI.findById(UI.hoveredEl.id);
           if (e == null) {
               return;
           }
           if (e.rawin("contextMenu") && e.contextMenu != null) {
               local cm = e.contextMenu;

               if (cm.rawin("options") && cm.options != null && cm.options.len() > 0 ){
                    local ctxID =e.id+ "::"+ Script.GetTicks()+"::ContextMenu";
                    if (UI.openContextID != null && UI.openContextID != ctxID){
                        local ctx =  UI.Canvas(UI.openContextID);

                        if (ctx != null){
                            ctx.destroy();
                            if (cm.rawin("onHide")){
                                cm.onHide();
                            }
                            UI.openContextID= null;
                            UI.hoveredEl=null;

                        }
                   }
                    UI.openContextID = ctxID;
                    local options = [];
                    local y = 0;
                    local data = null;

                    if (e.data.rawin("childOf") && e.data.childOf == "DataTable" ) {
                        local table = UI.DataTable(e.parents[e.parents.len()-1]);
                        data = table.getData(e.data.idx);
                        local arr = table.dataPages[table.page-1];
                        local rowID = table.id+"::table::row"+arr.find(data);

                       table.selectRow(arr, UI.Canvas(rowID));
                    }

                    if ( cm.rawin("type") && cm.type == "canvas") {
                        local DEFAULT_TEXT_COLOR = Colour(0,0,0);
                        local DEFAULT_BG_COLOR = Colour(255,255,255,255);


                        foreach (i,e in cm.options) {

                            local b =  UI.Canvas({
                                    id = ctxID+"::option"+i ,

                                    parents = [ctxID],
                                    Size = e.rawin("Size") ? e.Size : VectorScreen(50,25),
                                    Position = VectorScreen(0,y),
                                    onClick = e.onClick,
                                    data = { buttonID =  ctxID, row = data },
                                    onHoverOver = function(){
                                        this.Colour.A = 205;
                                    },
                                    onHoverOut = function(){
                                        this.Colour.A = this.data.defaultAlpha;
                                    }
                                    children = [
                                        UI.Label({
                                            id = ctxID+"::option"+i+":label"
                                            Text = e.name
                                            TextColour =  e.rawin("textColour") ? e.textColour : DEFAULT_TEXT_COLOR,
                                            onClick = e.onClick
                                            align = "center"
                                            data = { buttonID =  ctxID, row = data },
                                             onHoverOver = function(){
                                                local cb = ::UI.Canvas(this.parents[1]);
                                                if (cb != null){
                                                    cb.Colour.A = 205;
                                                }

                                            },
                                            onHoverOut = function(){
                                                local cb = ::UI.Canvas(this.parents[1]);
                                                if (cb != null) {
                                                    cb.Colour.A = cb.data.defaultAlpha;
                                                }


                                            }
                                        })
                                    ]
                            });
                            b.addBorders({
                                size = 1
                                color = ::Colour(0,0,0,240)
                            });
                            if (e.rawin("color")){
                                b.Colour = e.color;
                            }else{
                                 b.Colour = DEFAULT_BG_COLOR;
                            }
                            b.data.defaultAlpha <- b.Colour.A;
                            options.push(b);

                            y+=b.Size.Y
                        }
                    } else {

                        foreach (i,e in cm.options) {
                            local b =  UI.Button({
                                    id = ctxID+"::option"+i ,
                                    Text = e.name,
                                    TextColour =  e.rawin("textColour") ? e.textColour : Colour(0,0,0),
                                    parents = [ctxID],
                                    Size = e.rawin("Size") ? e.Size : VectorScreen(50,25),
                                    Position = VectorScreen(0,y),
                                    onClick = e.onClick,
                                    data = { buttonID =  ctxID, row = data}
                            });
                            if (e.rawin("color")){
                                b.Colour = e.color;
                            }
                            options.push(b);

                            y+=b.Size.Y;
                        }
                    }

                    UI.Canvas({
                        id = ctxID,
                        Color= Colour(0,0,0,150),
                        Position =GUI.GetMousePos(),
                        Size = VectorScreen(50, y),
                        children = options,
                        parents = [e.id]
                    });


               }
           }
       }
    }
});