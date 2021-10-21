class UIGrid extends DecUIComponent {

    className =  "Grid";

    columns = null;
    rows = null;
    cellWidth = null;
    cellHeight = null;
    data = null;
    Position = null;

    background = null;
    borderStyle = null;
    margin = null;
    totalSlots = null;
    filledSlots = null;
    nextEmptySlot = null;
    cellIDs = null;
    onHoverOverCell =null;
    onHoverOutCell = null;
    onCellClick = null;

    constructor(o) {
        base.constructor(o);

        this.margin = 0;
        this.cellIDs = [];
        this.ignoreGameResizeAutoAdjust=true;

        if (o.rawin("rows") && o.rows != null){
            this.rows =o.rows;
        }else{
             this.rows = 10;
        }
        if (o.rawin("columns") && o.columns != null){
            this.columns =o.columns;
        }else{
             this.columns =10;
        }
        if (o.rawin("cellWidth") && o.cellWidth != null){
            this.cellWidth =o.cellWidth;
        }else{
             this.cellWidth = 50;
        }
        if (o.rawin("cellHeight") && o.cellHeight != null){
            this.cellHeight =o.cellHeight;
        }else{
             this.cellHeight = 50;
        }

         if (o.rawin("data") && o.data != null){
            this.data =o.data;
        }else{
             this.data = [];
        }


         if (o.rawin("onHoverOverCell")){
            this.onHoverOverCell = o.onHoverOverCell;
        }
        if (o.rawin("onCellClick")){
            this.onCellClick = o.onCellClick;
        }
         if (o.rawin("onHoverOutCell")){
            this.onHoverOutCell = o.onHoverOutCell;
        }
         if (o.rawin("margin")){
            this.margin = o.margin;
        }


         if (o.rawin("background")){
            this.background = o.background;
        }else{
            this.background = Colour(150,150,150,0);
        }

        if (o.rawin("borderStyle")){
            this.borderStyle = o.borderStyle;
        }


        this.totalSlots = this.rows*this.columns;
        this.filledSlots = this.data.len();



        this.build();

    }



    function build(){

        local wrapper = UI.Canvas({
            id = this.id,
            presets = this.presets
            align = this.align,
            context = this,
            move = this.move
            Color =this.background
        });

        local maxX = 0;
        local maxY = 0;

        local drawY = 0;
        local drawX = 0;
        local globalIt = 0;
        for (local rowIdx = 0; rowIdx < this.rows; rowIdx++) {

            for (local colIdx = 0; colIdx < this.columns; colIdx++) {

                local cellCanvas = UI.Canvas({
                    id = this.id+"::"+rowIdx+"_"+colIdx
                    context = this
                     ignoreGameResizeAutoAdjust =true
                    Size = VectorScreen(this.cellWidth, this.cellHeight)
                    Position = VectorScreen(drawX, drawY)
                    onHoverOver = function(){
                        if (context.onHoverOverCell != null){
                            context.onHoverOverCell(this);
                        }
                    }
                    onHoverOut = function(){
                        if (context.onHoverOutCell != null){
                            context.onHoverOutCell(this);
                        }
                    }
                    onClick = function(){
                        if (context.onCellClick != null){
                            context.onCellClick(this);
                        }
                    }
                });
                this.cellIDs.push(cellCanvas.id);
                 cellCanvas.addBorders(this.borderStyle == null ? {} : this.borderStyle);
                 wrapper.add(cellCanvas, false);
                if (this.data.len() > globalIt){
                    local content = this.data[globalIt].content;
                    cellCanvas.add(content, false);
                }else{
                    if (this.nextEmptySlot == null){
                        this.nextEmptySlot = this.cellIDs.len()-1;
                    }
                }
                drawX +=this.cellWidth+this.margin;
                if (maxX < drawX) {
                    maxX = drawX;
                }
                globalIt++;

            }
            drawX = 0;

            drawY +=this.cellHeight+this.margin;
            if (maxY < drawY) {
                maxY = drawY;
            }

        }
        wrapper.Size.X = maxX-this.margin;
        wrapper.Size.Y = maxY-this.margin;
        wrapper.realign();
        wrapper.move = this.move;
        wrapper.resetMoves();
        wrapper.shiftPos();

    }

    function add(component) {
        local cellCanvas = UI.Canvas(this.cellIDs[this.nextEmptySlot]);
        component.Size.X = this.cellWidth;
        component.Size.Y = this.cellHeight;
        cellCanvas.add(component, false);
        this.filledSlots++;
        this.nextEmptySlot++;
    }

    function put(component, row, col) {
        local cellCanvas = UI.Canvas(this.id+"::"+row+"_"+col );
        if (cellCanvas !=null){
            component.Size.X = this.cellWidth;
            component.Size.Y = this.cellHeight;
            cellCanvas.add(component, false);
            this.filledSlots++;
        }

    }

     function removeLast() {

        local cellCanvas = UI.Canvas(this.cellIDs[this.nextEmptySlot]);

        if (cellCanvas != null) {
            this.nextEmptySlot--;
            filledSlots--;
            cellCanvas.removeChildren();
              cellCanvas.addBorders(this.borderStyle == null ? {} : this.borderStyle);
        }
    }


}

UI.registerComponent("Grid", {
    create = function(o) {
        local c = UIGrid(o);
        return c;

    }
});


