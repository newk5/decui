  local pr = {        
        //background = Colour(200,0,0,50),
        headerTextColor = Colour(255,0,0), 
        cellTextColor = Colour(100,200,0),
        headerTextSize = 20
       
    };


local t = UI.DataTable({
    id="tbl", 
    contextMenu = {
         options = [
             { 
                 name = "Option 1",
                 color = Colour(255,0,0),
                 onClick = function() {
                     local row = this.data.row; //clicked row
                     Console.Print("option1"+row.col1); 
                     
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
    rowStyle = {
         style ={
             cellTextColor = Colour(255,255,255),
          //   rowColor = Colour(230,0,20,100),
             cellTextSize = 12,
             borderColor =Colour(255,255,255), 
             borderSize = 2
         },
         condition = function(row){
             return false;
         }
     }
    renderRow = function(row){
         return true;
    }, 
    style = {
         background = Colour(51,	57,	61,200),
         headerTextColor = Colour(51,150,255),
         cellTextColor = Colour(255,255,255),
         headerTextSize = 20,  
         cellTextSize = 15,
         selectedRowColor = Colour(52,129,216,80)
       //  borderColor =Colour(255,255,255),
       //  borderSize = 2
      //   rowColor = Colour(200,0,0,50)
    },
    onRowClick = function(row){
         //this.removeRow(row);
        
    },
    columns =  [
         { header = "Column1", field = "col1"},
         { header = "Column2", field = "col2" },
         { header = "Column3", field = "col3" },
         { header = "Column4", field = "col4" },
         { header = "Column5", field = "col5" }
       
    ]
    data = [
         { col1 = "vaaa", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "asds"  },
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "vall", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "last1", col2 = "last2", col3 = "last3", col4 = "last4", col5 = "last5"},
         { col1 = "vaaa", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         { col1 = "val1", col2 = "val2", col3 = "val3", col4 = "val4", col5 = "val5"},
         
    ]
});