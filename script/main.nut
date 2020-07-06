dofile("decui/decui.nut");
dofile("debug.nut")
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

seterrorhandler(errorHandling);

function labelAndInput(o, moveObj) {
    local bg = :: Colour(50, 50, 50, 200);
    local pink = Colour(233, 158, 253);
    local white = Colour(255, 255, 255, 150);
    local size = VectorScreen(100, 25);

    if (o.rawin("inputSize")) {
        size = o.inputSize;
    }

    return InputGroup(

        {
            id = o.labelID
            Text = o.label
            TextColour = white

        },
        {
            id = o.inputID
            Text = ""
            Size = size
            Colour = bg
            TextColour = :: Colour(255,255,255)
        },
        moveObj
    )
}


selectedWeps <- [];
 wepNames <- [
         "Fist", "BrassKnuckle", "ScrewDriver",
        "GolfClub", "NightStick", "Knife",
        "BaseballBat", "Hammer", "Cleaver",
        "Machete", "Katana", "Chainsaw",
        "Grenade", "RemoteGrenade",
        "TearGas", "Molotov", "Missile",
        "Colt45", "Python", "Shotgun",
        "Spaz", "Stubby",
        "Tec9", "Uzi", "Ingrams", "MP5",
        "M4", "Ruger", "SniperRifle",
        "LaserScope", "RocketLauncher",
        "FlameThrower", "M60", "Minigun",
        "Bomb", "Helicannon"
    ]

 

function Script::ScriptLoad(){
  local c = UI.Canvas({
      id = "WepsMenu"  
      Colour = Colour(200,0,0)
      children = [
          UI.Canvas({
              id = "WepsMenuSet0"  
              children = [
                    UI.Label({
                        id = "newLabelID"  
                        Text = "labelText" 
                    })  
              ]  
          })
      ]
  })
  c.destroy(); 
  printList("labels")
} 


function getSelectedWepNames() {
    local names = "";
    foreach (id in ::selectedWeps) {
        if (names != "")
            names += ", "+::wepNames[id];
        else
            names += ::wepNames[id];
    }
    return names;
}

function getWepType( idWep){
     if (idWep==1){
        return "Brass Knuckle";
    }else if (idWep > 1 && idWep <= 11){
        return "Melee";
    } else if (idWep > 11 && idWep <= 15){  
        return "Throwable";
    }  else if (idWep == 16){
        return "Heavy";
    } else if (idWep > 16 && idWep <= 18){
        return "Pistols";
    } else if (idWep >=19 && idWep < 22){
        return "Shotguns"; 
    } else if (idWep >= 22 && idWep <= 25){
        return "SMGs";
    } else if (idWep > 25 && idWep <= 27){
        return "Assault Rifles";
    } else if (idWep > 27 && idWep < 30){
        return "Snipers";
    } else if (idWep >= 30 && idWep < 34){
        return "Heavy";
    } 
}

function hasWep(idWep){
    local t = getWepType(idWep);
    for (local i = 0; i < ::selectedWeps.len() ; i++ ) {
        if (::getWepType(selectedWeps[i])== t){
            return true;
        }
    }
    return false;

}









