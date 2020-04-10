
UI.Cursor("ON"); 

local t = UI.DataTable({
    id="tbl", 
    beforePageChange = function (oldPage, newPage) {
        Console.Print(oldPage+", "+newPage);
    }
    contextMenu = {
         options = [
             { 
                 name = "Delete",
                 color = Colour(255,0,0),
                 onClick = function() {
                     local row = this.data.row; //clicked row

                     UI.DataTable("tbl").removeRow(row);
                 }
                  
             },
             { 
                 name = "Option 2", 
                 onClick = function() { 
                     Console.Print("option2");
                 }
             },
             {
                 name = "Option 3",
                 onClick = function() {
                     Console.Print("option3"); 
                 }
             }
             
         ]
     },
    align = "center", 
    rows = 10,
 //   lazy = false,
    rowStyle = {
         style ={
             cellTextColor = Colour(255,255,255), 
             rowColor = Colour(230,0,20,100),
             cellTextSize = 12,
             borderColor =Colour(255,255,255), 
             borderSize = 2
         },
         condition = function(row){
             return false; 
         }
     }
    renderRow = function(row){
         return row.col1 != "val11";
    }, 
    onRowClick = function(row){
        local idx =this.indexOfRow(row);
        Console.Print("clicked row "+this.indexOfRow(row));
        
    },
    columns =  [ 
         { header = "Column1", field = "col1"},
         { header = "Co", field = "col2" },
         { header = "Column3", field = "col3" },
         { header = "cx", field = "col4" },
         { header = "Column5", field = "col5" }
       
    ]
    data = [
       { col1 = "val1aaaaaaaaaaaaaaaaaaaaaaaaaa", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val2", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val3", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "asds"  },
         { col1 = "val4", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val5", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "asds"  },
         { col1 = "val6", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val7", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "asds"  },
         { col1 = "val8", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "asds"  },
         { col1 = "val9", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val10", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "asds"  },
          { col1 = "val11", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val12", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val13", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val14", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val15", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val16", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
           { col1 = "val17", col2 = "1", col3 = "val3", col4 = "val4", col5 = "asds"  },
          { col1 = "val18", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val19", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val20", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val21", col2 = "1", col3 = "val3", col4 = "val4", col5 = "val5"},
          { col1 = "val22", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"}, 
          { col1 = "val23", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"}
         
    ] 
});
