  class Fetch {

    UI = null;
      
    constructor(ui) {
      this.UI =ui;
     
    } 

    function label(id){
      return UI.findByID(id, UI.lists[UI.names.find("labels")]);
    }
    
    function popup(id){
      return UI.findByID(id, UI.lists[UI.names.find("popups")]);
    }

    function editbox(id){
      return UI.findByID(id, UI.lists[UI.names.find("editboxes")] );
    } 
    function canvas(id){
       return UI.findByID(id, UI.lists[UI.names.find("canvas")]  );
    }
    function checkbox(id){
      return UI.findByID(id, UI.lists[UI.names.find("checkboxes")] );
    }
    function listbox(id){
      return UI.findByID(id, UI.lists[UI.names.find("listboxes")] );
    }
     function memobox(id){
      return UI.findByID(id, UI.lists[UI.names.find("memoboxes")]  );
    }
    function button(id){
      return UI.findByID(id, UI.lists[UI.names.find("buttons")] );
    }
    function window(id){
      return UI.findByID(id,  UI.lists[UI.names.find("windows")]);
    }
    function sprite(id){
      return UI.findByID(id, UI.lists[UI.names.find("sprites")] );
    }
     function scrollbar(id){
      return UI.findByID(id,  UI.lists[UI.names.find("scrollbars")] );
    }
    function progressBar(id){ 
      return UI.findByID(id, UI.lists[UI.names.find("progbars")] );
    }
  }
