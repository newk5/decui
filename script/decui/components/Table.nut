class Table extends Component {

    data = null;
    rows = null;
    totalRows = null;
    id = null;
    pages = null;
    Position = null;
    columns = null;
    align = null;
    move = null;
    page = null;
    dataPages = null;
    pagesLabel = null;

    onRowClick = null;
    style = null;
    tableHeight = 0;
    lastSelectedRowID = null;
    prevPage = 1;
    renderRow = null;
    rowStyle = null;
    contextMenu = null;


    constructor(o) {
        this.dataPages = [];
        if (o.rawin("id")){
            this.id = o.id;
        }
        if (o.rawin("style")){
            this.style = o.style;
        }
        if (o.rawin("rowStyle")){
            this.rowStyle = o.rowStyle;
        }
        if (o.rawin("renderRow")){
            this.renderRow = o.renderRow;
        }
         if (o.rawin("contextMenu")){
            this.contextMenu = o.contextMenu;
        }
        if (o.rawin("onRowClick")){
            this.onRowClick = o.onRowClick;
        }
         if (o.rawin("rows")){
            this.rows = o.rows;
        }
         if (o.rawin("align")){
            this.align = o.align;
        }
         if (o.rawin("move")){
            this.move = o.move;
        }else{
            move = {};
        }
         if (o.rawin("columns")){
            this.columns = o.columns; 
        }
        if (o.rawin("data")){ 
            this.data = [];
           // this.addHeaderRows(this.data);
           foreach (i, d in o.data ) {
                local render = this.renderRow == null ? true : this.renderRow(d);
                if (render){
                    this.data.push(d);
                }
           }
            //this.data.extend(o.data);
            this.totalRows = this.data.len();

            this.pages = ceil(this.totalRows.tofloat() / (this.rows == null ? 10 : this.rows ).tofloat());
            this.populatePages()
           
        }
        if (o.rawin("Position") && o.Position != null){
            this.Position = o.Position;
        }else{
            this.Position = VectorScreen(0,0);
        }
        page = 1;

         pagesLabel = UI.Label({
            id =this.id+"::table::pagesLabel",
            Text = "Page 1 of "+this.pages,
            align = "bottom_center",
            TextColour = Colour(255,255,255)

        })
         base.constructor(this.id);
        this.build(false);
        
    }

    function getData(idx){
        if (idx != null) {
            local index = this.page - 1;
            if (index >= 0){
                local arr = this.dataPages[index];
                return arr[idx];
            }
            
        }
        return null;
        
    }

    function populatePages(){
       
        local dataPages = [];
        local lastIdx = this.rows;
        local startIdx = 0;
        for (local i = 0; i < this.pages; i++){

            local arr = [];
            arr = this.addHeaderRows(arr); 
            arr = this.getDataRange(startIdx, lastIdx, arr); 
            this.dataPages.push(arr);
            startIdx = lastIdx;
            if (lastIdx > this.totalRows){
                break;
            }
            lastIdx +=this.rows;
        }
    }

    function clear(){
        
         foreach (i, c in this.columns) { 
             local colCanvID = this.id+"::table::column::canvas"+i;
             UI.Canvas(colCanvID).destroy();
         } 
    }

    function getDataRange(s, e, arr){
         
        try {
           
            for (local i = s; i < e; i++){
                arr.push(this.data[i]);
            }
        } catch(e) {

        }
        return arr;
    }

    function addHeaderRows(list){
        local obj = {  };
         foreach (idx, c in this.columns ) {  
           
             obj[c.field] <- c.header;
         }
         
        list.push(obj);
        return list;
    }
 
    function nextPage(){
         
        if (this.page < this.pages){
            this.clear();
            this.page++;
            this.build(true);
            if (this.page == this.pages){
                UI.Sprite(this.id+"::table::nextBtn").Alpha = 100;
                UI.Sprite(this.id+"::table::prevBtn").Alpha = 255;
            }else{
                  UI.Sprite(this.id+"::table::prevBtn").Alpha = 255;
            }
            UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
        }        
        
    }

    function prevPage(){
        if (this.page > 1){
           
            this.clear();
            this.page--;
            this.build(true);
            if (this.page == 1){
                UI.Sprite(this.id+"::table::prevBtn").Alpha = 100;
                UI.Sprite(this.id+"::table::nextBtn").Alpha = 255; 
            }else{
                  UI.Sprite(this.id+"::table::nextBtn").Alpha = 255;
            }
            UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
        }
        
    } 

    function addRow(o){
        this.clear();
        local validPage = false; 
        local lastPage = this.pages-1;

        if (this.dataPages[lastPage].len() < this.rows+1){
            
            this.dataPages[lastPage].push(o);
          
            validPage = true;
        }
         this.data.push(o);
        
        if (!validPage) { //new page added

            local newPage = this.addHeaderRows([]);
            newPage.push(o);

            this.dataPages.push(newPage);

            this.page++;  
            this.pages++;
            UI.Sprite(this.id+"::table::nextBtn").Alpha = 100;
        }
       
        this.build(true); 
       
        UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
    }

    function removeRow(o){
        local found = false;
        foreach(idx, arr in this.dataPages) {
            
            local item = arr.find(o);
            if (item ==0){
                break;
            } 
            if (item != null){
                this.dataPages[idx].remove(item);
                UI.Canvas( this.id+"::table::row"+item ).data.selected = false;
                local index = this.data.find(o);
                this.data.remove(index);
                found = true;
                
            }
            
        }
        if (found){   
            this.dataPages.clear();
            this.populatePages();
            this.totalRows = this.data.len();
            this.pages = ceil(this.totalRows.tofloat() / (this.rows == null ? 10 : this.rows ).tofloat());
            this.clear();
            if (this.page > this.pages){
                this.page--;
            } 
            this.build(true);
            UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
            if (this.page == 1){
                UI.Sprite(this.id+"::table::prevBtn").Alpha = 100;
            }
            if (this.pages == 1){
                UI.Sprite(this.id+"::table::nextBtn").Alpha = 100;
            }
         
            
        }
    }

    function setPage(p){
        if (p > 0 &&  p <= this.totalRows && this.page != p) {        
            this.page = p;
            this.clear();
            this.build(true);
            UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
        }
    }

    function build(rebuild){
        local start = Script.GetTicks();

        local canv = null;
        if (!rebuild) {
            canv = UI.Canvas({
                id= this.id,
                data = {},
                context = this,
                Position = this.Position,
                align = this.align,
                move = this.move, 
                Colour = Colour(255,255,255,255),
                Size =  VectorScreen(100,58)
            });
            if (style != null && style.rawin("background")){
                canv.Colour = style.background;
            }
        }else{
            canv = UI.Canvas(this.id);
        }
       
       local lastHeaderPos = this.drawTable(canv, rebuild);        
       
        if (!rebuild) {

            canv.Size.X = lastHeaderPos.X ;
            canv.Size.Y = lastHeaderPos.Y +35 ;

            tableHeight = lastHeaderPos.Y;

            canv.shiftPos();
            canv.realign();

            canv.addBorders({
                color = this.style.rawin("borderColor") ? this.style.borderColor : Colour(0,0,0,150),
                size = this.style.rawin("borderSize") ? this.style.borderSize :  2
            });

            pagesLabel.move = {up = 8};
            canv.addChild(pagesLabel);
            pagesLabel.realign();
            pagesLabel.shiftPos();

            local prevBtn = UI.Sprite({
                id= this.id+"::table::prevBtn",
                file ="decui/left.png",
                align = "bottom_center",
                Size = VectorScreen(21,21),
                move = { up = 8, left = 50 },
                context = this,
                Alpha = 100, 
                onHoverOver = function(){
                    this.Size = VectorScreen(24,24);
                },
                 onHoverOut = function(){
                    this.Size = VectorScreen(21,21);
                },
                onClick = function(){
                   context.prevPage();
                  
                }
            }); 

            local nextBtn = UI.Sprite({
                id= this.id+"::table::nextBtn",
                file ="decui/right.png",
                align = "bottom_center",
                Size = VectorScreen(21,21),
                move = { up = 8, right = 50 },
                context = this,
                onHoverOver = function(){
                    this.Size = VectorScreen(24,24); 
                },
                 onHoverOut = function(){
                    this.Size = VectorScreen(21,21);
                },
                onClick = function(){
                    context.nextPage();
                    
                }
            });

            canv.addChild(prevBtn);
            prevBtn.realign();
            prevBtn.shiftPos();

            canv.addChild(nextBtn);
            nextBtn.realign();
            nextBtn.shiftPos();
        }
        local end = Script.GetTicks();
        Console.Print("table built in "+(end-start)+"ms");
    } 

    function applyLabelPreset(l, c, isHeader, row) {
        if (isHeader){
            if (c.rawin("style") && c.style.rawin("headerTextColor")){
                l.TextColour = c.style.headerTextColor;
            }else if (style != null && style.rawin("headerTextColor")) {
                l.TextColour = style.headerTextColor;
            }
            if (c.rawin("style") && c.style.rawin("headerTextSize")){
                l.FontSize = c.style.headerTextSize;
            } else if (style != null && style.rawin("headerTextSize")) {
                l.FontSize = style.headerTextSize;
            }
        }else{
            if (this.rowStyle != null && this.rowStyle.rawin("style") && this.rowStyle.rawin("condition") && this.rowStyle.style.rawin("cellTextColor") && this.rowStyle.condition != null && this.rowStyle.condition(row)){
                l.TextColour = this.rowStyle.style.cellTextColor;
            } else if (c.rawin("style") && c.style.rawin("cellTextColor")){
                l.TextColour = c.style.cellTextColor;
            } else if (style != null && style.rawin("cellTextColor")) {
                l.TextColour = style.cellTextColor;
            }
            if (this.rowStyle != null && this.rowStyle.rawin("style") && this.rowStyle.rawin("condition") && this.rowStyle.style.rawin("cellTextSize") && this.rowStyle.condition != null && this.rowStyle.condition(row)){
                l.FontSize = this.rowStyle.style.cellTextSize;
            }else if (style != null && style.rawin("cellTextSize")) {
                l.FontSize = style.cellTextSize;
            }
        }
    }

    function applyRowColor(row, rowData){

        if (this.rowStyle != null && this.rowStyle.rawin("style") && this.rowStyle.rawin("condition") && this.rowStyle.style.rawin("rowColor") && this.rowStyle.condition != null && this.rowStyle.condition(rowData)){

            row.Colour = this.rowStyle.style.rowColor; 
            row.data.defaultColor  <- Colour (row.Colour.R, row.Colour.G, row.Colour.B, row.Colour.A);
        }else  if (this.style != null && this.style.rawin("rowColor")  ) {
            row.Colour = this.style.rowColor; 
            row.data.defaultColor  <- Colour (this.style.rowColor.R,this.style.rowColor.G,this.style.rowColor.B, this.style.rowColor.A);
        }        
    }

    function applyRowBorder(idx, row,rowData) {
        local borderStyle = null;
         //apply border styles, check for the conditional row styling object values first
        if ( idx > 0 && this.rowStyle != null && this.rowStyle.rawin("style") && this.rowStyle.rawin("condition")  && this.rowStyle.condition != null && this.rowStyle.condition(rowData)){
            borderStyle = {};
            if (this.rowStyle.style.rawin("borderColor")){
                borderStyle["borderColor"] <- this.rowStyle.style.borderColor;
            }
            if (this.rowStyle.style.rawin("borderSize")){
                borderStyle["borderSize"] <- this.rowStyle.style.borderSize;
            }
        } else {
            borderStyle = {
                borderColor = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,100),
                borderSize = this.style.rawin("borderSize") ? this.style.borderSize: 1
            };
            
        }
        
        return borderStyle;
    }

    function selectRow(arr, row) {

        if (this.style.rawin("selectedRowColor")){
            row.Colour = this.style.selectedRowColor;
        }else {
            row.Colour.A = 35;
         }
        if (this.lastSelectedRowID != null && !row.data.selected) {
            local r = UI.Canvas(this.lastSelectedRowID);
            if (r != null) {
                r.Colour.A = row.data.rawin("defaultColor") ? row.data.defaultColor.A : 0;
                r.data.selected = false;
            }
        }
         row.data.selected = true;
        this.lastSelectedRowID = row.id;
        this.onRowClick(arr[row.data.idx]);
    }

    function drawCanvasRow(cellX, idx, rowPos) {
       
        local row = UI.Canvas({
             
            id = this.id+"::table::row"+idx,
            Position = VectorScreen(0, rowPos.ypos),
            context = this,
            data = {idx=idx,selected = false, page= this.page, childOf= "DataTable"},
            onClick  = function(){
                local arr = context.dataPages[context.page-1];
                if (this.data.idx < arr.len()){
                    if (context.onRowClick != null) { 
                        context.selectRow(arr,this);
                    } 
                } 
            }
            Size = VectorScreen(cellX,  rowPos.height),   
             //   Colour = Colour(0,0,0,15),
            onHoverOver = function(){  
                if (!this.data.selected) {
                    this.Colour.A = 15;
                }
            },
            onHoverOut = function(){
                if (!this.data.selected) { 
                    if (this.data.rawin("defaultColor")){
                        this.Colour.A = this.data.defaultColor.A; 
                    }else{
                        this.Colour.A = 0;
                    }
                }  
            },
            contextMenu = this.contextMenu                    
        });
        return row;
    } 
   
    function drawCellContent (row, rowIdx, column, columnIndex, rowY){
        local cellIsHeader = rowIdx ==0 ;
        local labelConstructor = "flags";   
        if (row.rawin(column.field)){
            local value = row[column.field];
            if (typeof value == "string"){
                 local l = UI.Label({
                    id = this.id+"::table::cell"+rowIdx+"-"+columnIndex,
                    Text =value,
                    metadata =  { labelConstructor = labelConstructor },
                    Position = VectorScreen(0, rowY)
                });
                 
                if (cellIsHeader){  
                    l.FontFlags = GUI_FFLAG_BOLD;
                    l.align = "top_center";
                } 

                this.applyLabelPreset(l, column, cellIsHeader,row);
                return l;
            }else{
                value.Position = VectorScreen(0, rowY);
                rowY+= value.Size.Y;
                return value;
            }
        }else{
            local l = UI.Label({
                id = this.id+"::table::cell"+rowIdx+"-"+columnIndex,
                Text ="",
                 metadata =  { labelConstructor = labelConstructor },
                Position = VectorScreen(0, rowY)
            });
            if (cellIsHeader){  
                l.FontFlags = GUI_FFLAG_BOLD;
                l.align = "top_center";
            } 
            this.applyLabelPreset(l, column, cellIsHeader,row);             
            return l;
        }
    }

    function buildColumn(cellX, columnIdx, column){
        local c  = UI.Canvas({
               id =this.id+"::table::column::canvas"+columnIdx,
               Position = VectorScreen(cellX,0), 
               Size = VectorScreen(0,0)
        }); 
        if (column.rawin("background")){
            c.Colour = column.background;
        }
        return c;
    }


    function fillRowsMetadata() {
         local rowsMetadata = []; 
        for (local i = 0; i <= this.rows+1 ; i++) {
            rowsMetadata.push( {ypos = 0, height = 0});
        }
        return rowsMetadata;
    }

    function drawTable(canv, rebuild){
    
        local rowY = 0;
        local cellX = 0;
        local colCanv  = null;

        local rowsMetadata = this.fillRowsMetadata();
 
        foreach (columnIdx, column in this.columns) {
           
            colCanv = this.buildColumn(cellX, columnIdx, column);
             
            local index = this.page-1;
            foreach(rowIdx, row in this.dataPages[index]) {
               
                local cellIsHeader = rowIdx ==0 ;
               
                local content = this.drawCellContent(row,rowIdx,column,columnIdx, rowY);
               
                rowsMetadata[rowIdx].ypos = rowIdx == 1 ? rowY-5 : rowY;
                rowsMetadata[rowIdx].height = rowIdx == 1 ?  content.Size.Y+5 :content.Size.Y;

                //set the Y coord to drawn the horizontal line and add it to the Y coords array
                rowY +=  content.Size.Y + (cellIsHeader ? 5 : 1); 
               
                //increase the column canvas height and width
                if (colCanv.Size.Y < rowY){
                    colCanv.Size.Y = rebuild ? this.tableHeight : rowY;
                    // colCanv.Size.Y +=5; 
                } 
                if (colCanv.Size.X < content.Size.X){ 
                    colCanv.Size.X =content.Size.X+5;
                } 
            
                //add the label to the column canvas
                colCanv.addChild(content);
            }

            colCanv.addRightBorder({
                color = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,150),
                size =  this.style.rawin("borderSize") ? this.style.borderSize : 1 
            });
            if (column.rawin("style") && column.style.rawin("background")){
                colCanv.Colour = column.style.background;
            }
            canv.addChild(colCanv); 

            cellX += colCanv.Size.X; 
            rowY = 0;

            //center column header text
            UI.Label(this.id+"::table::cell0-"+columnIdx).realign();
            
        } 

      // draw canvas rows
        foreach (idx, rowPos in rowsMetadata) {
            if (rebuild) { 

                local oldRow = UI.Canvas(this.id+"::table::row"+idx);
                if (oldRow !=null){
                    oldRow.destroy();
                }
            }
            local arr = this.dataPages[this.page-1];

            if (idx < arr.len()) {

                local row = this.drawCanvasRow(cellX, idx, rowPos);
                
                local rowData = arr[idx];
                 local borderStyle = null;
                if (idx > 0){
                    this.applyRowColor(row,rowData);
                }
                borderStyle = this.applyRowBorder(idx, row,rowData);  

                row.addBottomBorder({
                    color =borderStyle.borderColor,
                    size = borderStyle.borderSize
                });
                canv.addChild(row);
               
                if (idx == this.rows){
                   this.drawHline(canv, cellX, idx, rowPos.ypos+rowPos.height);
                }
               
            }
               
        }
        
        return VectorScreen(cellX, colCanv.Size.Y);
    }

    function drawHline(canvas, size, row,y) {
        canvas.addChild(
            UI.Canvas({
                id =this.id+"::table::row:::line"+row,
                Position = VectorScreen(0,y),
                Size = VectorScreen(size,1),
                Colour = Colour(0,0,0,150)
            })
        );
       
    }

   
   

}