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
        
        opts["value"] <- null;
        opts["el"] <- [ ]; //element types
        opts["elID"] <- []; //element ids
    
        //events
        opts["onChange"] <- null;
        opts["onPush"] <- null;
        opts["onPop"] <- null;
        opts["onDecrement"] <- null;
        opts["onIncrement"] <- null;

       
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

    function set(key, val, op = "set"){
       
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
                                if (op =="set"){
                                     oldField[field] = val;
                                }else if (op=="push"){
                                    oldField[field].push(val); 
                                } else if (op=="pop"){
                                    if (val ==0){
                                        oldField[field].pop(); 
                                    }else{
                                        oldField[field].push(val); 
                                    }
                                   
                                } else if (op=="inc"){
                                     if (val ==1){
                                        oldField[field] +=1; 
                                    }else{
                                        oldField[field] += val;
                                    }
                                } else if (op=="dec"){
                                    oldField[field].push(val); 
                                }
                               
                            }else{
                                oldVal = oldField[field][fields[idx+1]];
                                 if (op =="set"){
                                      oldField[field][fields[idx+1]] = val;
                                 } else if (op=="push"){
                                    oldField[field][fields[idx+1]].push(val);
                                } else if (op=="pop"){
                                    if (val ==0){
                                        oldField[field][fields[idx+1]].pop();
                                    }else{
                                        oldField[field][fields[idx+1]].remove(val);
                                    }
                                  
                                } else if (op=="inc"){
                                    if (val ==1){
                                        oldField[field][fields[idx+1]] += 1;
                                    }else{
                                        oldField[field][fields[idx+1]] += val;
                                    }
                                  
                                } else if (op=="dec"){
                                    if (val ==1){
                                        oldField[field][fields[idx+1]] -= 1;
                                    }else{
                                        oldField[field][fields[idx+1]] -= val;
                                    }
                                  
                                }
                               
                            }
                           
                            
                            this.triggerChange(o, val,oldVal,op);
                        }
                    }catch(ex) {

                    }
                }
               
            }
        } else if (this.data.rawin(key)){
           
            local o = this.data[key];
            local old = o.value;
            if (op =="set"){
                 o.value = val;
            } else if (op=="push") {
                o.value.push(val);
            } else if (op=="pop") {
                if (val ==0){
                    o.value.pop();
                }else{
                    o.value.remove(val);
                }
            } else if (op=="inc") {
                if (val ==1){
                    o.value +=1;
                }else{
                    o.value +=val;
                }
            } else if (op=="dec") {
                if (val ==1){
                    o.value -=1;
                }else{
                    o.value -=val;
                }
            }
           
            this.triggerChange(o, val, old, op);
           
        }
    }

    function sub(key, obj) {
        local o =this.getEntry(key);
      
        if (obj.onChange != null){
            o.onChange = obj.onChange;
        }
        if (obj.onPush != null){
            o.onPush = obj.onPush;
        }
        if (obj.onPop != null){
            o.onPop = obj.onPop;
        }
        if (obj.onDecrement != null){
            o.onDecrement = obj.onDecrement;
        }
         if (obj.onIncrement != null){
            o.onIncrement = obj.onIncrement;
        }
        
    }

    function triggerChange(o, newValue, oldValue, op = "set"){
       
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
        if (o.onPush != null && op =="push"){
            o.onPush(newValue)
        }
        if (o.onPop != null && op =="pop"){
            o.onPop(newValue)
        }
        if (o.onIncrement != null && op =="inc"){
            o.onIncrement(newValue)
        }
         if (o.onDecrement != null && op =="dec"){
            o.onDecrement(newValue)
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