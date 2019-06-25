dofile("debug.nut")
dofile("decui/decui.nut");


    function errorHandling(err) {
    local stackInfos = getstackinfos(2);

    if (stackInfos) {
        local locals = "";

        foreach(index, value in stackInfos.locals) {
            if (index != "this")
                locals = locals + "[" + index + "] " + value + "\n";
        }

        local callStacks = "";
        local level = 2;
        do {
            callStacks += "*FUNCTION [" + stackInfos.func + "()] " + stackInfos.src + " line [" + stackInfos.line + "]\n";
            level++;
        } while ((stackInfos = getstackinfos(level)));

        local errorMsg = "AN ERROR HAS OCCURRED [" + err + "]\n";
        errorMsg += "\nCALLSTACK\n";
        errorMsg += callStacks;
        errorMsg += "\nLOCALS\n";
        errorMsg += locals;

        Console.Print(errorMsg);
    }    
}   
  
seterrorhandler(errorHandling);


circle <- null;


function Script::ScriptLoad(){
    local start = Script.GetTicks();
    UI.Cursor("ON"); 
    local radius = 100;

/*
    ::circle =UI.Circle({
        id = "circle"
        Position = VectorScreen(500,500)
        radius = 100
        border = 4
        align = "center" 
    });  
    */  
  
           
    local c = UI.Canvas({
        id = "newCanvasID" 
        Size = VectorScreen(200, 200) 
       autoResize = true
        Colour = Colour(150,150,150)  
        align = "center"
        children = [
          /*  UI.Label({
                id = "newLabelID"  
                Text = "labelTexttttttttttttttttttttttttttttttttttttttttttttttttttttttttt" 
                align ="center"
            })*/
        ]
             
    })
    //c.add(l);
 //   Console.Print();
   dofile("TableDemo.nut")
   c.add(UI.DataTable("tbl"));
   // Console.Print(UI.DataTable("tbl").tableWidth+"!!");
   
     local end = Script.GetTicks();     
     Console.Print(end-start+"ms");
    // Console.Print(UI.lists[UI.names.find("canvas")].len()); 
  
  
} 


UI.registerKeyBind({    
    name= "G", //g
    kp= KeyBind(0x47),  
    onKeyUp = function() {
        ::circle.cross({
            color =::Colour(255,0,0)
            size = 2
        })
        ::circle.attachToMouse();
       // ::circle.removeFill(); 
        //::UI.Circle("circle").align = "center";
       // ::UI.Canvas("circle").realign();
       //::circle.cross(::Colour(255,0,0))
        
    }
});  
 
 UI.registerKeyBind({  
    name= "h", //h
    kp= KeyBind(0x48), 
    onKeyUp = function() {
        //::circle.detachFromMouse();
       // ::circle.fill(Colour(0,200,0)); 
       ::showElements();
    }
});  

function test(){
    Console.Print("test");
}
 
