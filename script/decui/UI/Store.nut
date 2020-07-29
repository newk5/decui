class  Store {
    
    data = null;
    constructor(d = {}) {
        this.data = {};
       
        foreach (key,v in d){
            local t = typeof v;
            if (t=="string" || t == "bool" || t=="integer"){
                this.put(key,v);
            }else{
                this.initDefaults(v);
                this.data[key] <- v;
            }
        }
       
        
    }

    function put(key, value, opts={value=null, el="", elID=""}) {
        this.initDefaults(opts);
        opts.value = value;
        this.data[key] <- opts;
    }

    function attachIDAndType(key,id, type) {
        if (this.data.rawin(key)){
            local o = this.getEntry(key);
            o.elID = id;
            o.el = type;
        }
    }

    function set(key, val){
        if (this.data.rawin(key)){
            local o = this.data[key];
            local old = o.value;
            o.value = val;
            if (o.el=="GUIEditbox" ){
                UI.Editbox(o.elID).Text =val+""; 
            } else if (o.el=="GUICheckbox"){
                if (val == true){
                     UI.Checkbox(o.elID).AddFlags(GUI_FLAG_CHECKBOX_CHECKED);
                }else{
                     UI.Checkbox(o.elID).RemoveFlags(GUI_FLAG_CHECKBOX_CHECKED);
                }
               
            } else if (o.el=="GUILabel"){
                UI.Label(o.elID).setText(val+""); 
            } 
            if (o.onChange != null){
                o.onChange(old, val);
            }
           
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
                foreach (field in fields ) {
                    val = val[field];
                }
                return val;
            }
        }
        if (this.data.rawin(key)){
            return this.data[key].value;
        }
        return null;
    }

    function getEntry(key){
        if (this.data.rawin(key)){
            return this.data[key];
        }
        return null;
    }

    function initDefaults(opts){
        
        if (!opts.rawin("value")){
            opts["value"] <- null;
        }
        if (!opts.rawin("el")){
            opts["el"] <- "";
        }
        if (!opts.rawin("elID")){
            opts["elID"] <- "";
        }
        if (!opts.rawin("onChange")){
            opts["onChange"] <- null;
        }

       
    }
}