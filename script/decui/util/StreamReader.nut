class StreamReader {

    identifier = null; //something to identify the stream (usually an int/byte)

    onComplete = null;

    responseObject = null;
    result = null;
    arraySize = null;

    isArray = null;
    list = null;
    context = null;
    firstValueAsByte = null;
    onArrayFilter = null;


    constructor(o) {
        this.list = [];
        this.isArray = false;
        this.arraySize = 0;
        this.firstValueAsByte = false;
        this.identifier = o.id;


         if (o.rawin("context")) {
            this.context = o.context;
        }
        if (o.rawin("onArrayFilter")) {
            this.onArrayFilter = o.onArrayFilter;
        }
         if (o.rawin("arraySize")) {
            this.arraySize = o.arraySize;
        }
        if (o.rawin("isArray")) {
            this.isArray = o.isArray;
        }

        if (o.rawin("responseObject")) {
            this.responseObject = o.responseObject;
        }
         if (o.rawin("onComplete")) {
            this.onComplete = o.onComplete;
        }
         if (o.rawin("firstValueAsByte")) {
            this.firstValueAsByte = o.firstValueAsByte;
        }




        ::UI.streamControllers.push(this);

        //Server.SendData(s);
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
         if (this.onArrayFilter !=  null){
                this.onArrayFilter(obj);
        }
        if (this.isArray){
            if (this.list.len()+1 > this.arraySize){
                this.list.clear();
            }
            this.list.push(obj);

            if (this.list.len() == this.arraySize && this.onComplete != null){
                this.onComplete(this.list);
                ::UI.removeStream(this.identifier);
            }
        }else{
            this.onComplete(obj);
             ::UI.removeStream(this.identifier);
        }



    }



}