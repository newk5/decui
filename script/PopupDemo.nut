UI.Popup({ 
    id = "pop",
    onYes = function(){ 
        Console.Print("yesss");
    },
     onNo = function(){ 
        Console.Print("noooo");  
    } 
     onClose = function(){
        Console.Print("closed");
    }  
});