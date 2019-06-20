class InputGroup {
    
    className = "InputGroup";
    labelObj = null;
    editboxObj = null;

    maxX = null;
    maxY = null;

 

    constructor(label, editbox) {
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

    function attachParent(parent, l, e) {
   

        l.parents = UI.mergeArray(parent.parents, parent.id);
        parent.add(l);
        e.parents = UI.mergeArray(parent.parents, parent.id);
        parent.add(e);
        
    }

    function remove(){

        UI.Label(labelObj.id).destroy();
        UI.Editbox(editboxObj.id).destroy();

    }

}