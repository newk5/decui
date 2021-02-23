class Component  {
    id = null;
    metadata = null;
    preDestroy = null;
    elementData = null;
    constructor(id, o) {
        this.id = id;
        this.metadata = { list = "", index = null };
        if (o.rawin("preDestroy") && o.preDestroy != null){
            this.preDestroy = o.preDestroy;
        }
    }
    function destroy() {
        if (this.preDestroy != null){
            this.preDestroy();
        }
        local instanceList = UI.lists[UI.names.find(this.metadata.list)];
        local i = instanceList.find(this);
        instanceList[i] = null;
        instanceList.remove(i);
        if (metadata.list == "datatables"){
            this.clear(); 
            this.removeRowBorders();
        } 
        UI.DeleteByID(this.id);
        if (UI.showDebugInfo){
             if (!UI.excludeDebugIds){
               UI.decData(this.metadata.list);
            }else{
                if (this.id.find("decui:debug")==null){
                   UI.decData(this.metadata.list);
                }
            }
           
        }
    }
    function show(restoreAlpha = true) {
        UI.Canvas(this.id).show(restoreAlpha);
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
      function resetMoves() {
        UI.Canvas(this.id).resetMoves();
    }
    function getCanvas(){
        return  UI.Canvas(this.id);
    }

    function getNestedIndexes(){
          return  UI.Canvas(this.id).getNestedIndexes();
    }

    function getParent(){
        return getCanvas().getParent();
    }
  
}