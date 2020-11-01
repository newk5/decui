class DualProgBar extends Component {
   
    className =  "DualProgBar"; 
   
   
    Position = null;
    move = null;
    align = null;
   
    constructor(o) {
       
        this.id = o.id; 
      

        if (o.rawin("align")){
            this.align = o.align;
        }
       
         if (o.rawin("move")){
            this.move = o.move;
        }else{
            this.move = {};
        }

         
        if (o.rawin("Position") && o.Position != null){
            this.Position = o.Position;
        }else{
            this.Position = VectorScreen(0,0);
        }
       
       

        base.constructor(this.id,o);
        this.metadata.list = "dualprogbars";
        this.build();
        
    } 

   
 
    function build(){

    }
  

}