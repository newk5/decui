dofile("decui/decui.nut");
dofile("debug.nut")

function printCallStacks(){
    local stackInfos = getstackinfos(2);

    if (stackInfos) {



        local callStacks = "";
        local level = 2;
        do {
            callStacks += "*FUNCTION [" + stackInfos.func + "()] " + stackInfos.src + " line [" + stackInfos.line + "]\n";
            level++;
        } while ((stackInfos = getstackinfos(level)));

        local errorMsg = "\n";
        errorMsg += "\nCALLSTACK\n";
        errorMsg += callStacks;


        Console.Print(errorMsg);
    }
}

function Script::ScriptLoad(){
 
   // dofile("GridDemo.nut")
   // dofile("TableDemo.nut")
    //dofile("NotificationDemo.nut")
    //dofile("PopupDemo.nut")
    //dofile("TabviewDemo.nut")
    
   
} 
