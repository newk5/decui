class InputGroup {
    
    className = "InputGroup";
    labelObj = null;
    editboxObj = null;
    wrapperId = null;

    maxX = null;
    maxY = null;
    move = null;
    id = null;

    constructor(label, editbox, move = {}) {
        this.labelObj = label;
        this.editboxObj = editbox;

        if (!editboxObj.rawin("Position")){
            editboxObj.Position <- VectorScreen(0,0);
        } 
          if (!labelObj.rawin("Position")){ 
            labelObj.Position <- VectorScreen(0,0);
        }

        local maxEditX = (editboxObj.Position.X + editboxObj.Size.X ) ;
        local maxEditY = (editboxObj.Position.Y + editboxObj.Size.Y ) ;

        this.maxX = maxEditX > labelObj.Position.X ? maxEditX : labelObj.Position.X;
        this.maxY = maxEditY  > labelObj.Position.Y ? maxEditY : labelObj.Position.Y;
        this.move = move;
       
    }

    function build(parent,x){

     
        local l = UI.Label(labelObj);
        local e = UI.Editbox(editboxObj); 

        e.Position.Y =  e.Position.Y + l.Size.Y;
        e.move = {right = 2+x};
        e.shiftPos();

        l.move = {right = 2+x}; 
        l.shiftPos();

        if (parent !=null) {
            this.attachParent(parent,l,e);
        }
        
    }

    function attachParent(parent) {
   
        this.id = labelObj.id+editboxObj.id+"::wrapper";

         local c=  UI.Canvas({
            id = this.id
            Size = VectorScreen(0, 0)  
            autoResize = true   
        });


        local l = UI.Label(labelObj);
        local e = UI.Editbox(editboxObj); 

        l.parents = UI.mergeArray(parent.parents, parent.id);
       
        e.parents = UI.mergeArray(parent.parents, parent.id);
       

        e.Position.Y =  e.Position.Y + l.Size.Y;
        e.move = {right = 2, down = 10};
        e.shiftPos();

        l.move = {right = 0}; 
        l.shiftPos();

        c.add(l, false);
        c.add(e, false);
        
        parent.add(c, false);
        //«c.addBorders({})
        if (this.move != null){
            c.move = this.move;
            c.shiftPos();
        }
       
       
        
    }

    function destroy(){

        UI.Label(labelObj.id).destroy();
        UI.Editbox(editboxObj.id).destroy();

    }

}