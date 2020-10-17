class  Store {
    
    data = null;
    constructor(d = {}) {
        this.data = {};
     
        foreach (key,v in d){

            local t = typeof v;
            this.put(key,v);
           
            
        }

        
    }
      function initDefaults(opts){ 
        
        if (!opts.rawin("value")){
            opts["value"] <- null;
        }
        if (!opts.rawin("el")){
            opts["el"] <- [ ]; //element types
        }
        if (!opts.rawin("elID")){
            opts["elID"] <- []; //element ids
        }
        if (!opts.rawin("onChange")){
            opts["onChange"] <- null;
        }

       
    }

    function put(key, value) {
        local opts = {};
        this.initDefaults(opts);
        opts.value = value;

        this.data[key] <- opts;
        
    }

    function remove(key, id){
     
        local e = this.getEntry(key);
           
        if (e!=null){
                
            if (e.elID.len() == 1){
                
                delete  this.data[key];
            }else{
             
                local idx = e.elID.find(id);
                if (idx != null){
                  
                    e.elID.remove(idx);
                    e.el.remove(idx);

                }
            }
        }
    }

    function attachIDAndType(key,id, type) {
     
     
        if (key.find(".")){
            local fields = split(key,".");
            local o = this.getEntry(fields[0]);
            o.elID.push(id);
            o.el.push(type);
        }else if (this.data.rawin(key)){
            local o = this.getEntry(key);
            o.elID.push(id);
             o.el.push(type);
        }
    }

    function set(key, val){
         if (key.find(".")){
            local fields = split(key,".");
            local o = this.getEntry(fields[0]);
            local old = o.value;
           
            if (o != null){ 
                  
                local nestedField = o.value;
                fields = fields.filter(function(idx,e) {
                    return e != fields[0];
                });
                local offset =fields.len() == 1 ? 1: 2;
                foreach (idx,field in fields ) {
                    local oldField = nestedField;
                    try {  
                        
                        nestedField = nestedField[field]; 
                        if (idx == fields.len()-offset){

                            local oldVal=null;
                            if (offset==1){
                                oldVal = oldField[field];
                                oldField[field] = val;
                            }else{
                                oldVal = oldField[field][fields[idx+1]];
                                oldField[field][fields[idx+1]] = val;
                            }
                           
                            
                            this.triggerChange(o, val,oldVal);
                        }
                    }catch(ex) {

                    }
                }
               
            }
        } else if (this.data.rawin(key)){
            local o = this.data[key];
            local old = o.value;
            o.value = val;
            this.triggerChange(o, val, old);
           
        }
    }

    function sub(key, callback) {
        if (key.find(".")){
            local fields = split(key,".");
            local o = this.getEntry(fields[0]);
            o.onChange = callback;
        }else{
            local o = this.data[key];
            o.onChange = callback;
        }
    }

    function triggerChange(o, newValue, oldValue){
       
         if (o.el.len() >0){
            
            foreach (idx,id in o.elID) {
                local elt = o.el[idx];
                 if (elt=="GUIEditbox" ){
                    local c = UI.Editbox(id);
                    if (c!=null){
                        c.Text =newValue+""; 
                    }
                   
                } else if (elt=="GUICheckbox"){
                    local chk = UI.Checkbox(id);
                    if (chk != null){
                         if (newValue == true){
                            UI.Checkbox(o.elID).AddFlags(GUI_FLAG_CHECKBOX_CHECKED);
                        }else{
                            UI.Checkbox(o.elID).RemoveFlags(GUI_FLAG_CHECKBOX_CHECKED);
                        }
                    }
                   
                
                } else if (elt=="GUILabel"){
                    local l =UI.Label(id);
                    if (l != null){
                        l.setText(newValue+""); 
                    }
                    
                } else if (elt=="Listbox"){
                    local lst =  UI.Listbox(id);
                    if (lst != null){
                         lst.Clean();
                        foreach (i,item in newValue) {
                            lst.AddItem(item);
                        }
                    }
                   
                } else if (elt=="Combobox"){
                    local lst =  UI.ComboBox(id);
                    if (lst != null){
                        lst.Clean();
                        lst.setOptions(newValue);
                    }
                   
                } 
                    
            }
           
         }
     
        if (o.onChange != null){
            o.onChange(oldValue, newValue);
        }
    }

    
    function get(key){
        if (key.find(".")){
            
            local fields = split(key,"."); 

            local o = this.getEntry(fields[0]);

            if (o != null){
               
                local val = o.value;
                fields = fields.filter(function(idx,e) {
                    return e != fields[0];
                });
                local t = typeof val;

                if (t != "array") {
                    
                    foreach (field in fields ) {
                       
                        val = val[field];
                    }
                }
                 
                return val;
            }
        }else if (this.data.rawin(key)){
            return this.data[key].value;
        }
        return null;
    }

    function getEntry(key){
        if (key.find(".")){
            local fields = split(key,"."); 

             return this.data[fields[0]];
        } else if (this.data.rawin(key) ) {

            return this.data[key];
        }
        return null;
    }

  
}