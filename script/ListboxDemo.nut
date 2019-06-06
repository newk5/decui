UI.Listbox({ 
    id="lstBox",
    Size = VectorScreen(100,80),
    options = ["option1", "option2"],
    onOptionSelect = function(option){
        Console.Print(option);
    }
})  