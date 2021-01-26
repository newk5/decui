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
        opts["selectedValues"] <- [];
    
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

    function attachIDAndType(key,id, type, isSelectedValue=false) {
     
     
        if (key.find(".")){
            local fields = split(key,".");
            local o = this.getEntry(fields[0]);
            if (o != null){
                o.elID.push(id);
                o.el.push(type); 
                if (isSelectedValue){
                    o.selectedValues.push(id);
                }
                    
                    
            }
           
        }else if (this.data.rawin(key)){
            local o = this.getEntry(key);
            if (o != null){
                o.elID.push(id);
                o.el.push(type);
                if (isSelectedValue)
                    o.selectedValues.push(id);
            }
           
        }
    }

    function set(key, val, op = "set",dataUpdateOnly = false){
         
         if (key.find(".")){
            local fields = split(key,".");
            local o = this.getEntry(fields[0]);
            local old = o.value;
            
            if (o != null){  
                local newVal=val;      
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
                                    newVal = oldField[field][fields[idx+1]];
                                  
                                } else if (op=="dec"){
                                    if (val ==1){
                                        oldField[field][fields[idx+1]] -= 1;
                                    }else{
                                        oldField[field][fields[idx+1]] -= val;
                                    }
                                    newVal = oldField[field][fields[idx+1]];
                                }
                               
                            }
                           
                           
                            this.triggerChange(o, newVal,oldVal, op,dataUpdateOnly);
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
            local newVal = val;
            if (op=="dec" || op=="inc"){
                newVal=o.value;
            }
            this.triggerChange(o, newVal, old, op,dataUpdateOnly);
           
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

    function triggerChange(o, newValue, oldValue, op = "set", dataUpdateOnly=false){
       
        local triggerChange = !dataUpdateOnly;
         local vt = typeof newValue;
         if (triggerChange){
            
            foreach (idx,id in o.elID) {
                local elt = o.el[idx];
                 if (elt=="GUIEditbox" ){
                    local c = UI.Editbox(id);
                    if (c!=null){
                       
                        if (vt == "table" && c.bindTo.find(".")){
                            c.Text = UI.getData(c.bindTo);
                        }else{
                            c.Text =newValue+"";  
                        }
                        
                    }
                   
                } else if (elt=="GUICheckbox"){
                    local chk = UI.Checkbox(id);
                    if (chk != null){

                        if (vt == "table" && c.bindTo.find(".")){
                            local v = UI.getData(chk.bindTo);
                            local chkt = typeof v;
                            if (chkt == "bool"){
                                if (v){
                                     UI.Checkbox(o.elID).AddFlags(GUI_FLAG_CHECKBOX_CHECKED);
                                }else{
                                     UI.Checkbox(o.elID).RemoveFlags(GUI_FLAG_CHECKBOX_CHECKED);    
                                }
                            }
                        }else{
                           
                            if (newValue == true){
                                UI.Checkbox(o.elID).AddFlags(GUI_FLAG_CHECKBOX_CHECKED);
                            }else{
                                UI.Checkbox(o.elID).RemoveFlags(GUI_FLAG_CHECKBOX_CHECKED);
                            }
                        }
                    }
                   
                
                } else if (elt=="GUILabel"){
                     
                    local l =UI.Label(id);
                    if (l != null){
                       
                        if (vt == "table" && l.bindTo.find(".")){
                            l.setText(UI.getData(l.bindTo));
                        }else{
                            l.setText(newValue+"");  
                        }

                    }
                    
                } else if (elt=="GUIButton"){
                    local l =UI.Button(id);
                    if (l != null){
                        if (vt == "table" && l.bindTo.find(".")){
                            l.Text = UI.getData(l.bindTo);
                        }else{
                            l.Text =newValue+"";  
                        }
                    }
                    
                } else if (elt=="GUIMemobox"){
                    local lst =UI.Memobox(id);
                    if (op == "push") {
                        lst.AddLine(newValue);
                    } else if (op == "pop") {
                       /*
                        local itemToRemove = lst.Items[newValue];
                        
                        if (itemToRemove != null){
                            lst.RemoveItem(itemToRemove);
                        }
                        */
                    }  else if (op == "set"){
                        if (lst != null){
                            if (vt == "table" && lst.bindTo.find(".")){
                                local arr = UI.getData(lst.bindTo);
                                lst.Clear();
                                foreach (i,item in arr) {
                                    lst.AddLine(item);
                                } 
                            }else{
                                lst.Clear();
                                foreach (i,item in newValue) {
                                    lst.AddLine(item);
                                } 
                            }
                        }
                       
                    }
                    
                }  else if (elt=="GUIProgressBar"){
                    local l = UI.ProgressBar(id)
                    if (l != null){
                        if (op =="set"){
                            if (vt == "table" && l.bindTo.find(".")){
                                l.Value = UI.getData(l.bindTo);
                            }else{
                                l.Value =newValue;  
                            }
                           
                        } else if (op =="inc"){
                            l.Value +=newValue;
                        } else if (op =="dec"){
                            l.Value -=newValue;
                        }
                        
                    }
                    
                }  else if (elt=="Listbox"){
                    local lst =  UI.Listbox(id);
                      
                    if (lst != null){
                        if (op == "push") {
                             lst.AddItem(newValue);
                        } else if (op == "pop") {
                           
                            local itemToRemove = lst.Items[newValue];
                            
                            if (itemToRemove != null){
                                lst.RemoveItem(itemToRemove);
                            }
                            
                        }  else if (op == "set"){
                             if (vt == "table" && lst.bindTo.find(".")){
                                local arr = UI.getData(lst.bindTo);
                                lst.Clean();
                                foreach (i,item in arr) {
                                    lst.AddItem(item);
                                } 
                            }else{
                                lst.Clean();
                                foreach (i,item in newValue) {
                                    lst.AddItem(item);
                                } 
                            }
                          
                        }
                        
                    }
                   
                } else if (elt=="Combobox"){
                    local lst =  UI.ComboBox(id);
                    if (lst != null){ 
                        
                        if (op == "set"){
                            if (o.selectedValues.find(lst.id)==null){
                               
                                 if (vt == "table" && lst.bindTo != null && lst.bindTo.find(".")){
                                     
                                    local arr = UI.getData(lst.bindTo);
                                    lst.Clean();
                                    lst.setOptions(arr, false);
                                } else  if (vt == "string" && lst.bindToValue != null && lst.bindToValue.find(".")){
                                    
                                    local v = UI.getData(lst.bindToValue);
                                    lst.setText(v,false);
                                    lst.value= v;
                                } else{
                                    lst.Clean();
                                    lst.setOptions(newValue, false);
                                }
                            }else{
                                
                                  if (vt == "table" && lst.bindToValue.find(".")){
                                     
                                    local v = UI.getData(lst.bindToValue);
                                    lst.setText(v,false);
                                    lst.value= v;
                                } else if (vt == "string" && lst.bindToValue.find(".")){
                                    local v = UI.getData(lst.bindToValue);
                                    lst.setText(v,false);
                                    lst.value= v;
                                }else{
                                     lst.setText(newValue,false);
                                    lst.value= newValue;
                                }
                            }
                           
                           
                        }  else if (op == "pop") {

                            local itemToRemove = lst.options[newValue];
                            if (itemToRemove != null){
                                lst.removeItem(itemToRemove,false);
                            }
                        }  else if (op == "push"){
                           
                            lst.addItem(newValue,false);
                        }
                        
                    }
                   
                } else if (elt=="DataTable"){
                    local tbl =  UI.DataTable(id);
                    if (tbl != null){
                           
                        if (op == "set"){
                            local arr = newValue;
                            if (vt == "table" && tbl.bindTo.find(".")){
                                arr = UI.getData(tbl.bindTo);
                            }


                            tbl.clear();
                          
                            tbl.data = arr;
                            tbl.totalRows = arr.len();
                            tbl.pages  = ceil(tbl.totalRows.tofloat() / (tbl.rows == null ? 10 : tbl.rows ).tofloat());
                            tbl.dataPages.clear();
                          
                            tbl.populatePages();
                            tbl.tableHeight = 0;
                            tbl.build(true);

                        }  else if (op == "pop") {
                            
                            local itemToRemove = tbl.data[newValue];
                            if (itemToRemove != null){
                               
                                tbl.removeRow(itemToRemove,false);
                            }
                        }  else if (op == "push"){
                           
                            tbl.addRow(newValue,false);
                        }
                        
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