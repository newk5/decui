    function stringArray(a) {
        local str  = a.reduce(function(previousValue, currentValue){
            return (previousValue +","+ currentValue);
        });
        if (str == null) return "[ ]";
        return "[ "+str+" ]";
    }

    function printTable(t){
        foreach (k in t){
            Console.Print("{ "+k+"="+t+" }");
        }
    }

    function stringIDS(a){
      
        local str = "";
        foreach (s in a) {
            str = str+s.id+", ";
        }
        return "[ "+str+" ]";
    }

    function showElements(){
       Console.Print("-----------------------------------------------------------------")

         foreach (i, s in UI.names) {
            Console.Print(s +" --> "+UI.lists[i].len());
        } 
    }
    
    

    function printElementData(e) {
        if (e ==null) return;
        if (UI.idExists("element")) {
            UI.Label("elementID").Text = "ID: "+e.id;
            UI.Label("elementCoords").Text = "Position: "+e.Position.X+", "+e.Position.Y;
            UI.Label("elementSize").Text = "Size: "+e.Size.X+", "+e.Size.Y;
            UI.Label("elementParents").Text = "Parents: "+stringArray(e.parents);
            UI.Button("elementBtn").Text = "Highlight";
            UI.Canvas(e.id).updateBorders();
        }else{ 
             local el = UI.Canvas({
            id="element",
            Colour = Colour(100,100,100), 
            align="bottom_right",
            Size= VectorScreen(260, 160),
            children= [
                 UI.Label({
                    id = "elementID",
                    Text = "ID: "+e.id
                }),
                UI.Label({
                    id = "elementCoords",
                    Text = "Position: "+e.Position.X+", "+e.Position.Y,
                     move = { down = 10}
                }),
                 UI.Label({
                    id = "elementSize",
                    Text = "Size: "+e.Size.X+", "+e.Size.Y,
                    move = { down = 20} //stringArray
                }),
                 UI.Label({
                    id = "elementParents",
                    Text = "Parents: "+stringArray(e.parents),
                    move = { down = 30} //
                }),
                 UI.Button({
                    id = "elementBtn",
                    Text = "Highlight",
                    data = {id = e.id}
                    move = { down = 40} //
                    onClick = function (){
                        UI.Canvas(this.data.id).addBorders({ color = ::getroottable().Colour(255,0,0), size = 10 });
                    }
                })
            ]
            
        });
        }
       
        
    }


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