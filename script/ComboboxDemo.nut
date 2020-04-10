 UI.ComboBox({           
     id="combo",
     options = ["option1","option2","option3","option4"], 
     size = 150,
     Position = VectorScreen(300, 100),
     onOptionSelect = function(o){
         Console.Print(o+"!!!!!!!!!!!!");
     },
})