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
        }else{
            this.style = {
                background = Colour(51,57,	61,200),
                headerTextColor = Colour(51,150,255),
                cellTextColor = Colour(255,255,255),
                headerTextSize = 20,  
                cellTextSize = 12,
                selectedRowColor = Colour(52,129,216,80)
            
            };
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

    function indexOfRow(row){
         local arr = this.dataPages[this.page-1];
         return arr.find(row);
    }

    function populatePages(){
       
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
             UI.Canvas(colCanvID).remove();
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
       
        local validPage = false;  
        local lastPage = this.pages-1;
        this.totalRows++;
        if (this.dataPages[lastPage].len() < this.rows+1){
            
            this.dataPages[lastPage].push(o); 
          
            validPage = true;
            if (lastPage == this.page-1){ 
                this.clear();
            }     
        }
         this.data.push(o); 
         
        if (!validPage) { //new page added  

            local newPage = this.addHeaderRows([]);
            newPage.push(o);

            this.dataPages.push(newPage); 
  
            this.pages++; 
            if (this.page-1 == lastPage){
                UI.Sprite(this.id+"::table::nextBtn").Alpha = 255;
            }
           
        }else{

            if (lastPage == this.page-1){
                this.build(true);
               
            }
        }
        
     
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
            this.totalRows--;
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
        if (p != null && p > 0 &&  p <= this.totalRows && this.page != p) {        
            this.page = p;
            this.clear();
            this.build(true);
            UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
            if (this.page >= this.pages){
                UI.Sprite(this.id+"::table::prevBtn").Alpha = 255;
            }
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
        canv.Size.X = lastHeaderPos.X ;
        canv.Size.Y = lastHeaderPos.Y +35 ; 
        tableHeight = lastHeaderPos.Y;
        canv.shiftPos();
        canv.realign();
        canv.updateBorders();

        if (!rebuild) {

            canv.addBorders({
                color = this.style.rawin("borderColor") ? this.style.borderColor : Colour(0,0,0,150),
                size = this.style.rawin("borderSize") ? this.style.borderSize :  2
            });

            pagesLabel.move = {up = 8};
            canv.add(pagesLabel);
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
  
            canv.add(prevBtn); 
            prevBtn.realign();
            prevBtn.shiftPos(); 

            canv.add(nextBtn);
            nextBtn.realign();
            nextBtn.shiftPos();
        }else{
            pagesLabel.realign(); 
            pagesLabel.shiftPos();
            local nextBtn = UI.Sprite(this.id+"::table::nextBtn");
            local prevBtn =  UI.Sprite(this.id+"::table::prevBtn");
            nextBtn.realign();
            nextBtn.shiftPos();
            prevBtn.realign();
            prevBtn.shiftPos();

        }
       
        
        if (this.page >= this.pages){
            UI.Sprite(this.id+"::table::nextBtn").Alpha = 100;
        }
        local end = Script.GetTicks();
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

         local r = arr[row.data.idx];
        if (row.data.idx > 0){
            local idx =this.indexOfRow(r);
            local prev  = UI.Canvas(this.id+"::table::row"+(idx-1));
            local c = UI.Canvas(this.id+"::table::row"+idx);
            local prevPos = prev.Position.Y + prev.Size.Y;
            local diff = prevPos-c.Position.Y ;
            if (diff > 0){
                c.Size.Y -= diff;
                c.Position.Y += diff;
                c.updateBorders();
            }
        }
       

        
        this.onRowClick(r);
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
        local labelConstructor = "empty";   
        if (row.rawin(column.field)){
            local value = row[column.field];
            if (typeof value == "string"){
                 local l = UI.Label({
                    id = this.id+"::table::cell"+rowIdx+"-"+columnIndex,
                    Text =value,
                    metadata =  { labelConstructor = labelConstructor },
                    Position = VectorScreen(0, rowY)
                    //FontName = "Arial"
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
 
        local rowsToIncrease = [];
  
        foreach (columnIdx, column in this.columns) {
           
            colCanv = this.buildColumn(cellX, columnIdx, column);
            
            local index = this.page-1;
          
            foreach(rowIdx, row in this.dataPages[index]) {
                
                local cellIsHeader = rowIdx ==0 ;
                local h= false;
                local md = rowsMetadata[rowIdx];
                  local diff = 0; 
    
                if (rowY  > md.ypos) {
                   diff = rowY-md.ypos;
                   md.ypos = rowY;
                   h=true;
                   
                } else{
                    rowY = md.ypos;
                }
                local content = this.drawCellContent(row,rowIdx,column,columnIdx, rowY);
               
               if (content.Size.Y > md.height){
                     md.height = content.Size.Y+5;
                }   
               if (!cellIsHeader && h && columnIdx>0){
                    for (local i = columnIdx-1; i >= 0; i-- ){
                        local label = UI.Label(this.id+"::table::cell"+rowIdx+"-"+i);
                        label.Position.Y = rowY;   
                     
                    }
                     
                 
                    local hasRow = false;
                    local ridx = -1;
                    foreach (c, r in rowsToIncrease){
                        if (r.index == rowIdx){
                            hasRow = true;
                            ridx = c;
                            break;
                        }
                    }
                   
                    if (rowIdx >1){
                        try { 
                         local prevPos = rowsMetadata[rowIdx-1].ypos;
                         local dist = md.ypos - prevPos;
                         local pp = prevPos +  rowsMetadata[rowIdx-1].height;
                         local d = pp - md.ypos;
                         if (md.height < dist){
                            
                            if (hasRow &&  rowsToIncrease[ridx].px < diff){ 
                                rowsToIncrease[ridx].px = (dist -md.height);
                            }else{
                                rowsToIncrease.push({index = rowIdx, px = (dist -md.height) });
                            }
                         }
                        }catch (ex){
                         
                        }
                    }
                    
                }
                local add =content.Size.Y+5 ;
                            
                //set the Y coord to drawn the horizontal line and add it to the Y coords array
                rowY += add
              
                //increase the column canvas height and width
                if (colCanv.Size.Y < rowY){
                    colCanv.Size.Y = rebuild ? this.tableHeight : rowY;
                    // colCanv.Size.Y +=5; 
                } 
                if (colCanv.Size.X < content.Size.X){ 
                    colCanv.Size.X =content.Size.X+5;
                } 
               
                //add the label to the column canvas
                colCanv.add(content);
            }

            colCanv.addRightBorder({
                color = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,150),
                size =  this.style.rawin("borderSize") ? this.style.borderSize : 1 
            });
            if (column.rawin("style") && column.style.rawin("background")){
                colCanv.Colour = column.style.background;
            }
            canv.add(colCanv); 

            //if this column canvas' height is higher than previous' column canvas, increase their heights 
            if (columnIdx > 0){
                for (local i = columnIdx-1; i >= 0; i-- ){
                    
                     local prevCanvas = UI.Canvas(this.id+"::table::column::canvas"+i);
                    if (colCanv.Size.Y > prevCanvas.Size.Y){
                        prevCanvas.Size.Y = colCanv.Size.Y;
                        prevCanvas.removeBorders();
                       
                        prevCanvas.addRightBorder({
                            color = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,150),
                            size =  this.style.rawin("borderSize") ? this.style.borderSize : 1 
                        });
                    } 
                }
               
            }

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
                    oldRow.remove();
                }
            }
            local arr = this.dataPages[this.page-1];

            if (idx < arr.len()) {

                 foreach (c, r in rowsToIncrease){
                     if (r.index == idx) {
                         rowPos.ypos  -= r.px;
                         rowPos.height += r.px;
                     }
                 } 
                 

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
                canv.add(row);
               
                if (idx == this.rows){
                   this.drawHline(canv, cellX, idx, rowPos.ypos+rowPos.height);
                }
               
                if (idx == arr.len()-1){
                     
                    if (this.tableHeight >0 && this.tableHeight <= rowPos.ypos){
                        foreach (i, c in this.columns) { 
                           
                            local colCanvID = this.id+"::table::column::canvas"+i;
                            local col = UI.Canvas(colCanvID);
                            col.Size.Y += rowPos.height; 
                            this.tableHeight = col.Size.Y;
                            col.removeBorders();
                           
                             col.addRightBorder({
                                color = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,150),
                                size =  this.style.rawin("borderSize") ? this.style.borderSize : 1 
                            });
                        } 
                        //colCanv.Size.Y = rowPos.ypos +rowPos.height;
                    }  
                }
            }
           
            
        }

       
       
        
        return VectorScreen(cellX, colCanv.Size.Y);
    }

    function drawHline(canvas, size, row,y) {
        canvas.add(
            UI.Canvas({
                id =this.id+"::table::row:::line"+row,
                Position = VectorScreen(0,y),
                Size = VectorScreen(size,1),
                Colour = Colour(0,0,0,150)
            })
        );
       
    }

   
   

}