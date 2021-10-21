class DecUIComponent {
    id = null;
    metadata = null;
    preDestroy = null;
    elementData = null;
    parents = null;
    childLists = null;
    autoResize = null;
    delayWrap = null;
    data = null;
    align = null;
    Position = null;
    move = null;
    ignoreGameResizeAutoAdjust=null;
    presets = null;
    border = null;


    constructor(o) {
        foreach(key,value in o){
            if (this.rawin(key)){
                this[key] = value;
            }
       }
        this.id = o.rawin("id") ? o.id: "DecUI::RandomID"+::UI.GLOBAL_COUNTER;
        ::UI.GLOBAL_COUNTER++;
        this.metadata = {
            list = "",
            index = null
        };
        this.parents = [];
        this.presets = [];
        this.childLists = [];
        this.autoResize = false;
        this.delayWrap = false;
        this.align = o.rawin("align") ?  o.align:null;
        this.Position = o.rawin("Position") ?  o.Position: VectorScreen(0,0 );
        this.move = o.rawin("move") ?  o.move:{};
        this.ignoreGameResizeAutoAdjust = o.rawin("ignoreGameResizeAutoAdjust") ?  o.ignoreGameResizeAutoAdjust:false;

        if (o.rawin("preDestroy") && o.preDestroy != null) {
            this.preDestroy = o.preDestroy;
        }
    }


     //Receives a table and the full field name in "dotted notation"
    // For example given the table : { level1 =  { level2 = { level3 =  10 }  }  }
    // passing "level1.level2.level3" as "fullField" will return 10
    function getNestedData(table, fullField) {
        local fields = split(fullField, ".");
        local v = table;
        foreach(idx, field in fields) {

            if (idx + 1 <= fields.len()) {
                local nextField = idx == 0 ? fields[0] : fields[idx];
                if (v != null && typeof v == "table" && v.rawin(nextField)){
                    v = v[nextField];
                }else{
                    return v;
                }

            }
        }
        return v;
    }

    function getNestedDataOr(table, fullField,defaultValue) {
        local v = this.getNestedData(table,fullField);
        
        return v == null ? defaultValue: v;
    }

    function getMaxPosition() {
        return getCanvas().getMaxPosition();
    }

    function destroy() {
        if (this.preDestroy != null) {
            this.preDestroy();
        }
        local instanceList = UI.lists[UI.names.find(this.metadata.list)];
        local i = instanceList.find(this);
        instanceList[i] = null;
        instanceList.remove(i);
        if (metadata.list == "DataTable") {
            this.clear();
            this.removeRowBorders();
        }
        UI.DeleteByID(this.id);
        if (UI.showDebugInfo) {
            if (!UI.excludeDebugIds) {
                UI.decData(this.metadata.list);
            } else {
                if (this.id.find("decui:debug") == null) {
                    UI.decData(this.metadata.list);
                }
            }

        }
    }

    function show(restoreAlpha = true) {
        UI.Canvas(this.id).show(restoreAlpha);
    }

    function rePosition() {
        getCanvas().rePosition();
    }

    function hide() {
        UI.Canvas(this.id).hide();
    }

    function fadeIn(callback = {}) {
        UI.Canvas(this.id).fadeIn(callback);
    }

    function fadeOut(callback = {}) {
        UI.Canvas(this.id).fadeOut(callback);
    }

    function realign() {
        local canvas =  UI.Canvas(this.id);
        canvas.parents = this.parents;
        canvas.realign();
    }

    function shiftPos() {
        UI.Canvas(this.id).shiftPos();
    }

    function SendToTop() {
        UI.Canvas(this.id).SendToTop();
    }

    function SendToBottom() {
        UI.Canvas(this.id).SendToBottom();
    }

    function MoveForward() {
        UI.Canvas(this.id).MoveForward();
    }

    function MoveBackward() {
        UI.Canvas(this.id).MoveBackward();
    }

    function resetMoves() {
        UI.Canvas(this.id).resetMoves();
    }

    function getCanvas() {
        return UI.Canvas(this.id);
    }

    function getNestedIndexes() {
        return UI.Canvas(this.id).getNestedIndexes();
    }

    function getParent() {
        return getCanvas().getParent();
    }

    function updateBorders() {
        UI.updateBorders(this.getCanvas());
    }


    function resetPosition() {
        this.getCanvas().resetPosition();
    }

    function ignoresAutoAdjust() {
        return this.getCanvas().ignoresAutoAdjust();
    }
    function getChildren() {
        return this.getCanvas().getChildren();
    }

}