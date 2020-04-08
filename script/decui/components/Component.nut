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
        if (metadata.list == "datatables"){
            this.clear(); 
            this.removeRowBorders();
        } 
        UI.DeleteByID(this.id);
    }
    function show() {
        UI.Canvas(this.id).show();
    }
    function hide() {
        UI.Canvas(this.id).hide();
    }
     function fadeIn() {
        UI.Canvas(this.id).fadeIn();
    }
    function fadeOut() {
        UI.Canvas(this.id).fadeOut();
    }
    function realign() {
        UI.Canvas(this.id).realign();
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
}