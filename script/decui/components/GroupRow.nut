class GroupRow {

    className = "GroupRow";
    size = null;
    groups = null;

    currentX = null;
    currentY = null;
    parentSize = null;
    parentID = null;
    index = null;
    y = null;
    spacing = 100;
    move = null;


    constructor(o) {
        this.groups = o.items; 
        this.y = o.y;
        this.spacing = o.spacing;
        if (o.rawin("move")){
            this.move = o.move;
        }
        if (this.currentX == null) {
            this.currentX = 0;
        }
        if (this.currentY == null) {
            this.currentY = 0;
        } 
    } 

    function build(parent) {
        parentID = parent.id;
        parentSize = parent.Size;

        if (this.groups.len() > 0){
            local idx = index == null ? Script.getTicks() : index;
            local rowCanvas = UI.Canvas({
                id = this.parentID+"::GroupRow::"+idx, 
                Size = VectorScreen(parentSize.X, 50),
                Position = VectorScreen(0, this.y),
                move = this.move == null ? {}: this.move
            });
            local x = 0;
            foreach(i,group in this.groups) { 
              
                this.currentY += group.maxY;
                this.currentX += group.maxX;
               
                if (!this.isOverBounds(group)){
                  
                    group.build(rowCanvas,x);                   
                    x+=spacing;
            
                }
            }
            
            return rowCanvas;
        }

    }



    function isOverBounds(group){ 
      
        return (currentX + group.maxX) >  this.parentSize.X  || (currentY + group.maxY) >  this.parentSize.Y ;
    }

}