class StreamRequest {

    identifier = null; //something to identify the stream (usually an int)
    body = null; // array with the stream body
    onComplete = null;
    
    expectsResponse = null;
    responseObject = null;
    result = null;
    arraySize = null;
   
    isArray = null;
    list = null;
    context = null;
    


    constructor(o) {
        this.list = [];
        this.body = [];
        this.isArray = false;
        this.arraySize = 0;
        this.expectsResponse = false;

        this.identifier = o.id;
        
        if (o.rawin("body")) {
            this.body = o.body;
        }
         if (o.rawin("context")) {
            this.context = o.context;
        }
         if (o.rawin("arraySize")) {
            this.arraySize = o.arraySize;
        }
        if (o.rawin("isArray")) {
            this.isArray = o.isArray;
        }
   
        if (o.rawin("responseObject")) {
            this.responseObject = o.responseObject;
             this.expectsResponse = true;
        }
         if (o.rawin("onComplete")) {
            this.onComplete = o.onComplete;
        }
        
        
        local s = Stream();
         this.writeValue(s, identifier);    
        foreach (idx, v in body) {
            this.writeValue(s, v);
        }
        if (this.expectsResponse){
            ::UI.streamControllers.push(this);
        }
        Server.SendData(s);
       // Debug.SendData(s);

        
    }

    function readResponse(stream){
        local obj = {};

        foreach (idx, field in this.responseObject.fields){
            local v = this.responseObject.types[idx];

            if (v == "string"){
                obj[field] <-  stream.ReadString();
                
            } else if (v == "float"){
                 obj[field] <-  stream.ReadFloat();
            } else if (v == "integer"){
                 obj[field] <-  stream.ReadInt();
            } else if (v == "byte"){
                obj[field] <-  stream.ReadByte();
            }
        }
        if (this.isArray){
            if (this.list.len()+1 > this.arraySize){
                this.list.clear();
            }
            this.list.push(obj);
            
            if (this.list.len() == this.arraySize){
                this.onComplete(this.list);
                ::UI.removeStream(this.identifier);
            }
        }else{
            this.onComplete(obj);
             ::UI.removeStream(this.identifier);
        }


     
    }



    function writeValue(stream, value) {
        local t = typeof value;
        if (t == "string"){
            stream.WriteString(value);
        } else if (t == "float"){
            stream.WriteFloat(value);
        } else if (t == "integer"){
            stream.WriteInt(value);
        } else if (t == "byte"){
            stream.WriteByte(value);
        }
    }
    
}