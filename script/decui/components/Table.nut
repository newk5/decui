class Table extends DecUIComponent {

    className = "DataTable";
    data = null;
    rows = null;
    totalRows = null;

    pages = null;
    columns = null;

    page = null;
    dataPages = null;
    pagesLabel = null;

    onRowClick = null;
    style = null;
    tableHeight = null;
    lastSelectedRowID = null;
    prevPage = 1;
    renderRow = null;
    rowStyle = null;
    contextMenu = null;
    parentSize = null;
    tableWidth = null;
    isEmpty = false;
    noDataText = "";
    realRows = null;
    lazy = null;
    streamID = null;
    dataSize = null;
    rowModel = null;
    beforePageChange = null;
    afterPageChange = null;
    bindTo = null;
    awatingResponse = null;


    constructor(o) {
        base.constructor(o);
        this.dataSize = 0;
        this.tableHeight = 0;
        this.tableWidth =0;
        this.dataPages = [];
        this.data = [];
        this.awatingResponse = false;
        this.lazy = false;

        if (o.rawin("rowModel")){
            this.rowModel = o.rowModel;
        }
        if (o.rawin("beforePageChange")){
            this.beforePageChange = o.beforePageChange;
        }
        if (o.rawin("afterPageChange")){
            this.afterPageChange = o.afterPageChange;
        }

        if (o.rawin("bindTo")){
            this.bindTo = o.bindTo;
        }
         if (o.rawin("streamID")){
            this.streamID = o.streamID;
        }
         if (o.rawin("dataSize")){
            this.dataSize = o.dataSize;
            this.totalRows = this.dataSize;
        }else{
             this.totalRows = 0;
        }
        if (o.rawin("noDataText")){
            this.noDataText = o.noDataText;
        }
        if (o.rawin("style")){
            this.style = o.style;
        }else{
            this.style = {
                background = Colour(51,57,	61,200),
                headerTextColor = Colour(51,150,255),
                cellTextColor = Colour(255,255,255),
                outerBorderColor =  Colour(51,57,61,200)
                outerBorderSize =  2
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

         if (o.rawin("columns")){
            this.columns = o.columns;
        }


        page = 1;

        if (o.rawin("lazy") && o.lazy){
            this.lazy = o.lazy;
            this.awatingResponse = true;

            StreamRequest({
                context = this
                id = this.streamID
                body = [ 0 , this.rows ]
                expectsResponse = true
                arraySize = this.rows
                isArray = true
                responseObject = this.getRowModel()
                onComplete = function (arr) {

                    local firstPageData = { data = arr, total = this.context.dataSize };

                    context.isEmpty = firstPageData.data.len() == 0;
                    if (context.isEmpty){
                        firstPageData.data.push(context.getEmptyRow());
                    }
                    foreach (i, d in firstPageData.data ) {
                        context.data.push(d);
                    }

                    context.totalRows = firstPageData.total;
                    local tempData = [];


                    if (context.data.len() < context.totalRows) {
                        for (local i = 0;  i < (context.totalRows-context.data.len()); i++){
                            tempData.push(context.getEmptyRow());
                        }
                    }
                    context.data.extend(tempData);

                    context.pages = ceil(context.totalRows.tofloat() / (context.rows == null ? 10 : context.rows ).tofloat());
                    context.populatePages()

                    context.pagesLabel = UI.Label({
                        id =context.id+"::table::pagesLabel",
                        Text = "Page 1 of "+context.pages,
                        align = "bottom_center",
                        ignoreGameResizeAutoAdjust = true
                        TextColour = Colour(255,255,255)
                    })

                    context.build(false);
                    context.awatingResponse = false;

                }
            })


        } else {

            if (o.rawin("data")){
                 if (o.rawin("bindTo")){
                    UI.store.attachIDAndType(o.bindTo,o.id, "DataTable");
                    local val = UI.store.get(o.bindTo);
                    o.data = val;
                }
                this.isEmpty = o.data.len() == 0;
                if (isEmpty){
                    o.data.push(this.getEmptyRow());
                }


                foreach (i, d in o.data ) {
                    local render = this.renderRow == null ? true : this.renderRow(d);
                    if (render){
                        this.data.push(d);
                    }
                }
                this.totalRows = this.data.len();

                this.pages = ceil(this.totalRows.tofloat() / (this.rows == null ? 10 : this.rows ).tofloat());
                this.populatePages()

            }
        }

        if (!this.lazy){
            pagesLabel = UI.Label({
                id =this.id+"::table::pagesLabel",
                Text = "Page 1 of "+this.pages,
                align = "bottom_center",
                ignoreGameResizeAutoAdjust = true
                TextColour = Colour(255,255,255)
            })

            this.build(false);
        }



    }

    function lazySetPage(p){


        this.page = p;

        this.awatingResponse = true;
        StreamRequest({
            context = this
            id = this.streamID
            body = [ this.rows* (this.page-1) , this.rows ]
            expectsResponse = true
            arraySize = this.rows
            isArray = true
            responseObject = this.getRowModel()
            onComplete = function (arr) {

                local pageData =  { data = arr, total = context.dataSize };

                foreach (i, d in pageData.data ) {
                    local index = ( (context.page-1)+""+i).tointeger();
                    if (context.data.len()-1 >= index) {
                        context.data[index] = d;
                    } else {
                        context.data.push(d);
                    }
                }
                context.totalRows = pageData.total;
                context.pages = ceil(context.totalRows.tofloat() / (context.rows == null ? 10 : context.rows ).tofloat());
                context.lazyPopulatePages(context.page-1, pageData.data, context.rows* (context.page-1));
                context.clear();
                context.build(true);
                ::UI.Label(context.id+"::table::pagesLabel").Text = "Page "+context.page+" of "+context.pages;
                if (context.page >= context.pages){
                    ::UI.Sprite(context.id+"::table::prevBtn").Alpha = 255;
                }
                //re-apply table borders because the table size may change
                local wrapper = ::UI.Canvas(context.id);
                wrapper.removeBorders();
                wrapper.addBorders({
                    color = context.style.rawin("outerBorderColor") ? context.style.outerBorderColor : Colour(0,0,0,150),
                    size = context.style.rawin("outerBorderSize") ? context.style.outerBorderSize :  2
                });
                local lastLine =  ::UI.Canvas(context.id+"::table::row:::line"+context.rows);
                if (lastLine != null){
                    lastLine.Size.X = wrapper.Size.X;
                }

                context.awatingResponse = false;
            }
        })


    }

    function setPage(p){
        if (p != null && p > 0 &&  p <= this.pages && this.page != p && !this.awatingResponse) {
            local oldp = this.page;
            local newp = p;

            if (this.beforePageChange != null){
                this.beforePageChange(oldp, newp);
            }

            if (this.lazy) {
               this.lazySetPage(p);
            } else {
                this.page = p;
                this.clear();
                this.build(true);
                UI.Label(this.id+"::table::pagesLabel").Text = "Page "+this.page+" of "+this.pages;
                if (this.page >= this.pages){
                    UI.Sprite(this.id+"::table::prevBtn").Alpha = 255;
                }
                  //re-apply table borders because the table size may change
                local wrapper = UI.Canvas(this.id);
                wrapper.removeBorders();
                wrapper.addBorders({
                    color = this.style.rawin("outerBorderColor") ? this.style.outerBorderColor : Colour(0,0,0,150),
                    size = this.style.rawin("outerBorderSize") ? this.style.outerBorderSize :  2
                });
                local lastLine =  UI.Canvas(this.id+"::table::row:::line"+this.rows);
                if (lastLine != null) {
                    lastLine.Size.X = wrapper.Size.X;
                }
            }

            if (this.afterPageChange != null){
                this.afterPageChange(oldp, newp);
            }

        }
    }


    function lazyNextPage() {
        this.awatingResponse = true;
        StreamRequest({
            context = this
            id = this.streamID
            body = [ this.rows* (this.page) , this.rows]
            expectsResponse = true
            arraySize = this.rows
            isArray = true
            responseObject = this.getRowModel()
            onComplete = function (arr) {
                 local pageData =  { data = arr, total = context.dataSize };

                 foreach (i, d in pageData.data ) {
                    local index = (context.page+""+i).tointeger();
                    try {
                        context.data[index] = d;
                    } catch(ex) {
                    }
                }

                context.pages = ceil(context.totalRows.tofloat() / (context.rows == null ? 10 : context.rows ).tofloat());
                context.lazyPopulatePages(context.page, pageData.data, context.rows* (context.page));

                context.clear();
                context.page++;
                context.build(true);
                if (context.page == context.pages){
                    ::UI.Sprite(context.id+"::table::nextBtn").Alpha = 100;
                    ::UI.Sprite(context.id+"::table::prevBtn").Alpha = 255;
                }else{
                    ::UI.Sprite(context.id+"::table::prevBtn").Alpha = 255;
                }
                ::UI.Label(context.id+"::table::pagesLabel").Text = "Page "+context.page+" of "+context.pages;

               //re-apply table borders because the table size may change
                local wrapper = ::UI.Canvas(context.id);
                wrapper.removeBorders();
                wrapper.addBorders({
                    color = context.style.rawin("outerBorderColor") ? context.style.outerBorderColor : Colour(0,0,0,150),
                    size = context.style.rawin("outerBorderSize") ? context.style.outerBorderSize :  2
                });
                local lastLine =  ::UI.Canvas(context.id+"::table::row:::line"+context.rows);
                if (lastLine != null){
                    lastLine.Size.X = wrapper.Size.X;
                }

                context.awatingResponse = false;
            }
        })

    }

    function nextPage(){
        if (this.page < this.pages && !this.awatingResponse){

            if (this.lazy){

              this.lazyNextPage();
            }  else{

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

                 //re-apply table borders because the table size may change
                local wrapper = UI.Canvas(this.id);
                wrapper.removeBorders();
                wrapper.addBorders({
                    color = this.style.rawin("outerBorderColor") ? this.style.outerBorderColor : Colour(0,0,0,150),
                    size = this.style.rawin("outerBorderSize") ? this.style.outerBorderSize :  2
                });
                local lastLine =  UI.Canvas(this.id+"::table::row:::line"+this.rows);
                if (lastLine != null) {
                    lastLine.Size.X = wrapper.Size.X;
                }
            }


        }

    }

    function lazyPrevPage() {

            local startIdx =  (this.rows* (this.page-1))- this.rows;
          this.awatingResponse = true;
          StreamRequest({
            context = this
            id = this.streamID
            body = [ startIdx , this.rows]
            expectsResponse = true
            arraySize = this.rows
            isArray = true
            responseObject = this.getRowModel()
            onComplete = function (arr) {

                local pageData =  { data = arr, total = context.dataSize };

                foreach (i, d in pageData.data ) {

                    local index = (context.page-2+""+i).tointeger();
                    try {
                        context.data[index] = d;
                    }catch (ex) {
                        break;
                    }

                }
                        // this.totalRows = pageData.total;
                context.pages = ceil(context.totalRows.tofloat() / (context.rows == null ? 10 : context.rows ).tofloat());
                context.lazyPopulatePages(context.page-2, pageData.data, startIdx );

                context.clear();
                context.page--;
                context.build(true);
                if (context.page == 1){
                    ::UI.Sprite(context.id+"::table::prevBtn").Alpha = 100;
                    ::UI.Sprite(context.id+"::table::nextBtn").Alpha = 255;
                }else{
                    ::UI.Sprite(context.id+"::table::nextBtn").Alpha = 255;
                }
                ::UI.Label(context.id+"::table::pagesLabel").Text = "Page "+context.page+" of "+context.pages;

                //re-apply table borders because the table size may change
                local wrapper = ::UI.Canvas(context.id);
                wrapper.removeBorders();
                wrapper.addBorders({
                    color = context.style.rawin("outerBorderColor") ? context.style.outerBorderColor : Colour(0,0,0,150),
                    size = context.style.rawin("outerBorderSize") ? context.style.outerBorderSize :  2
                });
                local lastLine =  ::UI.Canvas(context.id+"::table::row:::line"+context.rows);
                if (lastLine != null){
                    lastLine.Size.X = wrapper.Size.X;
                }
                context.awatingResponse = false;
            }
        })


    }

    function prevPage(){
        if (this.page > 1 && !this.awatingResponse){
            if (this.lazy){

                this.lazyPrevPage();

            }else{

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

                //re-apply table borders because the table size may change
                local wrapper = UI.Canvas(this.id);
                wrapper.removeBorders();
                wrapper.addBorders({
                    color = this.style.rawin("outerBorderColor") ? this.style.outerBorderColor : Colour(0,0,0,150),
                    size = this.style.rawin("outerBorderSize") ? this.style.outerBorderSize :  2
                });
                local lastLine =  UI.Canvas(this.id+"::table::row:::line"+this.rows);
                if (lastLine != null) {
                    lastLine.Size.X = wrapper.Size.X;
                }

            }

        }

    }



    function getEmptyRow() {
        local obj = {};
        foreach (i, c in this.columns ) {
            obj[c.field] <- noDataText;
        }
        return obj;
    }

      function getRowModel() {
        return this.rowModel;
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

    function lazyPopulatePages(page, data, skip){
         local startIdx = skip;
         local lastIdx = startIdx+this.rows;

        local arr = [];
        arr = this.addHeaderRows(arr);
        arr = this.getDataRange(startIdx, lastIdx, arr);

        this.dataPages[page] = arr;


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
             local column = UI.Canvas(colCanvID);

             column.removeBorders();
             column.destroy();
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



    function addRow(o, triggerBind = true){
        if (this.awatingResponse){
            return;
        }
        if (this.isEmpty){
            this.data.remove(0);
            this.dataPages[0].remove(1);
            // ::printTable(this.dataPages[0][0]);
        }

        this.isEmpty= false;
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
        if (this.bindTo != null && triggerBind){
            UI.pushData(this.bindTo, o, true);
        }
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

    function lazyRemoveRow(o){

        local actualPage =this.page;
        this.pages = ceil((this.totalRows-1).tofloat() / (this.rows == null ? 10 : this.rows ).tofloat());

        if (this.page > this.pages){
            actualPage--;
        }

        this.awatingResponse = true;
        StreamRequest({
            context = this
            id = this.streamID
            body = [ this.rows* actualPage , this.rows]
            expectsResponse = true
            arraySize = this.rows
            isArray = true
            responseObject = this.getRowModel()
            onComplete = function (arr) {

                 local pageData =  { data = arr, total = context.dataSize };

                context.dataPages[idx].remove(item);
                context.data.remove(context.data.find(o));
                foreach (i, d in pageData.data ) {

                    local index = (actualPage+""+i).tointeger
                    try {
                        context.data[index] = d;
                    } catch(ex) {}

                }
                context.totalRows--;

                context.dataPages.clear();

                context.populatePages();
                context.totalRows = context.data.len();
                context.pages = ceil(context.totalRows.tofloat() / (context.rows == null ? 10 : context.rows ).tofloat());
                context.clear();


                if (context.page > context.pages){
                    context.page--;

                }
                context.build(true);
                UI.Label(context.id+"::table::pagesLabel").Text = "Page "+context.page+" of "+context.pages;
                if (context.page == 1){
                    UI.Sprite(thicontexts.id+"::table::prevBtn").Alpha = 100;
                }
                if (context.pages == 1){
                    UI.Sprite(context.id+"::table::nextBtn").Alpha = 100;
                }
                context.awatingResponse = false;
            }
        })


    }

    function removeRowBorders() {
        for(local i =0; i<= this.rows; i++) {
            local row = UI.Canvas( this.id+"::table::row"+i );
            if (row != null){
                row.removeBorders();
            }
        }
    }

    function removeRow(o, triggerBind = true){
        if (!this.isEmpty && !this.awatingResponse) {
            local isLastRow = this.totalRows == 1;
            if (isLastRow){
                this.isEmpty= true;
                this.dataPages[0][1] = this.getEmptyRow();
                this.data[0] =this.getEmptyRow();
                for (local i = 0; i< this.columns.len(); i++){

                    UI.Label(this.id+"::table::cell1"+"-"+i).Text = noDataText;
                }
                return;
            }

            local found = false;

            foreach(idx, arr in this.dataPages) {

                local item = arr.find(o);
                if (item ==0){
                    break;
                }
                if (item != null){

                    found = true;

                    if (this.lazy ){
                        this.lazyRemoveRow(o);

                    }else {
                        this.dataPages[idx].remove(item);
                         if (this.bindTo != null && triggerBind){
                            UI.popData(this.bindTo, idx, true);
                        }
                        UI.Canvas( this.id+"::table::row"+item ).data.selected = false;
                        local index = this.data.find(o);

                        this.data.remove(index);

                    }


                }


            }
            if (found && !this.lazy){

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


    }



    function build(rebuild){
        local start = Script.GetTicks();

        tableWidth = 0;
        local canv = null;
        if (!rebuild) {
            canv = UI.Canvas({
                id= this.id,
                presets = this.presets
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
                color = this.style.rawin("outerBorderColor") ? this.style.outerBorderColor : Colour(0,0,0,150),
                size = this.style.rawin("outerBorderSize") ? this.style.outerBorderSize :  2
            });

            pagesLabel.move = {up = 8};
            canv.add(pagesLabel, false);
            pagesLabel.realign();
            pagesLabel.shiftPos();

            local prevBtn = UI.Sprite({
                id= this.id+"::table::prevBtn",
                file ="decui/left.png",
                align = "bottom_center",
                ignoreGameResizeAutoAdjust = true
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
                    local firstPage = context.page==1;
                    if (context.beforePageChange != null && !firstPage){
                        context.beforePageChange(context.page, context.page-1);
                    }
                   context.prevPage();
                    if (context.afterPageChange != null && !firstPage ){
                        context.afterPageChange(context.page+1, context.page);
                    }

                }
            });

            local nextBtn = UI.Sprite({
                id= this.id+"::table::nextBtn",
                file ="decui/right.png",
                align = "bottom_center",
                ignoreGameResizeAutoAdjust = true
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
                    local lastPage = context.page==context.pages;
                    if (context.beforePageChange != null && !lastPage){
                        context.beforePageChange(context.page, context.page+1);
                    }
                    context.nextPage();
                    if (context.afterPageChange != null && !lastPage){
                        context.afterPageChange(context.page-1, context.page);
                    }

                }
            });

            canv.add(prevBtn, false);
            prevBtn.realign();
            prevBtn.shiftPos();

            canv.add(nextBtn, false);
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
       // canv.realign();
        canv.Size.X = tableWidth;
      //  canv.Size.Y = tableWidth;
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
        local hasValidRowStyle = this.rowStyle != null && this.rowStyle.rawin("style") && this.rowStyle.rawin("condition") && this.rowStyle.condition != null;
         //apply border styles, check for the conditional row styling object values first
        if ( idx > 0 && hasValidRowStyle   && this.rowStyle.condition(rowData)){
            borderStyle = {};
            local hasNoBorder = true;

            if (this.rowStyle.style.rawin("borderSize")){
                borderStyle["borderSize"] <- this.rowStyle.style.borderSize;
                hasNoBorder = false;

                if (this.rowStyle.style.rawin("borderColor")){
                    borderStyle["borderColor"] <- this.rowStyle.style.borderColor;
                    hasNoBorder = false;
                }
            }
            if (hasNoBorder){
                borderStyle = {
                    borderColor = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,100),
                    borderSize = this.style.rawin("borderSize") ? this.style.borderSize: 1
                };
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


        if (this.onRowClick != null){
             this.onRowClick(r);
        }

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
                    context.selectRow(arr,this);

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
            if (typeof value == "string" || typeof value == "integer" || typeof value == "float" || typeof value=="boolean"){
                 local l = UI.Label({
                    id = this.id+"::table::cell"+rowIdx+"-"+columnIndex,
                    Text =value,
                    metadata =  { labelConstructor = labelConstructor },
                    Position = VectorScreen(0, rowY)
                    ignoreGameResizeAutoAdjust = true
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
                 ignoreGameResizeAutoAdjust = true
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

    function changeHeader(column, newText){
        local key= null;
        foreach (i,k in this.dataPages[0][0]){
            local match = k == column;
            key = match ? i : null;
        }
        if (key != null) {
            for (local p = 0; p < this.pages; p++){
                this.dataPages[p][0][key] = newText;
            }
        }
        this.rebuild();
        foreach (c in this.columns){
            if (c.header == column){
                c.header = newText;
            }
        }

    }

    function rebuild() {
        this.clear();
        this.build(true);
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


                rowY += add

                //increase the column canvas height and width
                if (colCanv.Size.Y < rowY){
                    colCanv.Size.Y =  rowY;
                }
                if (colCanv.Size.X < content.Size.X){
                    colCanv.Size.X =content.Size.X+5;
                }

                colCanv.add(content, false);
            }

            colCanv.addRightBorder({
                color = this.style.rawin("borderColor") ? this.style.borderColor: Colour(0,0,0,150),
                size =  this.style.rawin("borderSize") ? this.style.borderSize : 1
            });
            if (column.rawin("style") && column.style.rawin("background")){
                colCanv.Colour = column.style.background;
            }
            canv.add(colCanv, false);

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
        //    canv.Size.Y = rowY;
            rowY = 0;

            tableWidth = cellX;

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

                row.addBorders({
                    color =borderStyle.borderColor,
                    size = borderStyle.borderSize
                });
                canv.add(row, false);

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
        if (!UI.idExists(this.id+"::table::row:::line"+row)) {
            canvas.add(
                UI.Canvas({
                    id =this.id+"::table::row:::line"+row,
                    Position = VectorScreen(0,y),
                    Size = VectorScreen(size,1),
                    Colour = Colour(0,0,0,150)
                }), false
            );
        }


    }

}

UI.registerComponent("DataTable", {
    create = function(o) {
        local c = Table(o);
        return c;

    }
});