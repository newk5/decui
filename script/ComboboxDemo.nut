 UI.ComboBox({           
     id="combo",
     options = ["option1","option2"], 
     size = 150,
     Position = VectorScreen(20, 100),
     onOptionSelect = function(o){
         Console.Print(o+"!!!!!!!!!!!!");
     },
})