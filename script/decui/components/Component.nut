class Component  {
    id = null;
    metadata = null;
    constructor(id) {
        this.id = id;
        metadata = { list = "", index = null };
    }
    function destroy() {
     
        local instanceList = UI.lists[UI.names.find(this.metadata.list)];
        local i = instanceList.find(this);
        instanceList[i] = null;
        instanceList.remove(i);
        UI.DeleteByID(this.id);
    }
    function show() {
        UI.Canvas(this.id).show();
    }
    function hide() {
        UI.Canvas(this.id).hide();
    }
    function realign() {
        UI.Canvas(this.id).realign();
    }
}