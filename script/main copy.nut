dofile("decui/decui.nut");
dofile("decui/debug.nut");



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


function Script::ScriptLoad() {  
    
    UI.Cursor("ON");
  
   UI.ProgressBar({
       id = "progBarID"  
       Value = 10
       MaxValue = 100
       Size = VectorScreen(GUI.GetScreenSize().X, 22)
       StartColour = Colour(54,88,55)
       EndColour  =  Colour(77,152,78)
       Thickness = 3
       align = "bottom"
   }) 

   UI.Label({
       id = "lvlPoints"  
       Text = "16/100" 
       TextColour = ::Colour(255,255,255)
       align = "bottom"
       move = {up = 4}
       fontFlags = GUI_FFLAG_BOLD
   })
    UI.Label({
       id = "lvlRank"  
       Text = "Rank 1" 
       TextColour = ::Colour(255,255,255)
       align = "bottom_left"
       move = {up = 4, right = 3}
       fontFlags = GUI_FFLAG_BOLD
   })
     UI.Label({
       id = "lvlRank2"   
       Text = "Rank 2" 
       TextColour = ::Colour(255,255,255)
       align = "bottom_right"
       move = {up = 4, left = 3}
       fontFlags = GUI_FFLAG_BOLD
   })
   ::Timer.Create(this, function(text) { //skill effect over
       ::UI.ProgressBar("progBarID").Value +=1;
    }, 50,0, "skillActiveTimer"+Script.GetTicks());
 
 
    local ID = "root"+Script.GetTicks();
    local bg = ::Colour(50,50,50, 200);
    local pink = Colour(233,158,253);
    local white = Colour(255,255,255,150);
    local blue = Colour(100,172,255,150);
    local green = Colour(131,193,129,100);
    local yellow = Colour(230,231,92,100);
    local black =Colour(0,0,0,150);
    

     local g1 = UI.Grid({
        id = "gridSelf"
        align = "top_center" 
        move = { down = "15%"}
        rows =2
        columns =4
        margin = 5
        borderStyle = {
            color =black
            size = 2
        }
        onHoverOverCell = function(cell){
            //cell.Colour = ::Colour(150,200,150);
        }
        onHoverOutCell = function(cell){
           // cell.Colour = ::Colour(150,150,150);
        }
        onCellClick = function(cell){
        //    cell.Colour = ::Colour(150,150,200);
        }
        
    }); 
    local g2 = UI.Grid({
        id = "gridInfant"
        align = "top_center" 
        move = { down = "15%"}
        rows =2
        columns =4
        margin = 5
        borderStyle = {
            color =black
            size = 2
        }
        onHoverOverCell = function(cell){
            //cell.Colour = ::Colour(150,200,150);
        }
        onHoverOutCell = function(cell){
           // cell.Colour = ::Colour(150,150,150);
        }
        onCellClick = function(cell){
        //    cell.Colour = ::Colour(150,150,200);
        }
        
    }); 
     local g3 = UI.Grid({
        id = "gridTeam"
        align = "top_center" 
        move = { down = "15%"}
        rows =2
        columns =4
        margin = 5
        borderStyle = {
            color =black
            size = 2
        }
        onHoverOverCell = function(cell){
            //cell.Colour = ::Colour(150,200,150);
        }
        onHoverOutCell = function(cell){
           // cell.Colour = ::Colour(150,150,150);
        }
        onCellClick = function(cell){
        //    cell.Colour = ::Colour(150,150,200);
        }
        
    }); 
    
     

    local tv = UI.TabView({

       id="tabview",
       align = "bottom",
       move = {down = 0}
       Size = VectorScreen(224,200), 
       onTabClicked = function(t){
          Console.Print(t +" tab clicked");
       },  
       style = {
           activeTabColor =Colour(51,57,61,250)
           borderColor = Colour(0,0,0,0)
           headerBorderColor =Colour(0,0,0)
           headerInactiveBorderColor = Colour(0,0,0)
           background =Colour(51,57,61,0),
           onHoverTabColor = Colour(51,57,61,250)
       }
    
       tabs = [ 
            {  
                title = "SELF",
                style = { titleColor = blue } 
                content = [ g1  ]
            },
            { 
                title = "INFANTRY"
                style = { titleColor = yellow }
                content = [ g2  ]
            },
            { 
                title = "TEAM"
                style = { titleColor = green }
                content = [ g3  ]
            }
          
       ]
    }); 
    local wrapper = UI.Canvas({
        id = "skillGridCanvas"
        Color = Colour(51,57,61,250)
        Size = VectorScreen(224,290) 
        align = "center" 
        autoResize = true 
        children = [
             UI.Label({
                id = "pointsLabel"   
                Text = "100 Points" 
                TextColor = white  
                FontSize = 15
                align = "top_center"
               move =  { down =60, left = -1}
                FontName = "Arial" 
                FontFlags = GUI_FFLAG_OUTLINE | GUI_FFLAG_BOLD | GUI_FFLAG_ITALIC
            })
            UI.Label({
                id = "skillsLabelCanvas"   
                Text = "Available Skills" 
                TextColor = pink  
                FontSize = 25
                align = "top_center"
               move =  { down =25, left = -1}
                FontName = "Arial" 
                FontFlags = GUI_FFLAG_OUTLINE | GUI_FFLAG_BOLD | GUI_FFLAG_ITALIC
            })
            UI.Sprite({
                id = "skillCanvasCloseBtn"  
                file = "decui/closew2.png" 
                Size = VectorScreen(24,24)
                align = "top_right"
                move = { down = 4, left = 6 }
              
            })
            tv
        ]    
    });
    wrapper.addBorders({color = black});

     for (local i = 1; i <= 13; i++ ){
        local col = i == 6 || i == 4 ? green:blue;
        if (i <=5){
            col = blue;
        } else if (i <=8){
            col = yellow;
        } else{
             col = green; 
        }
        local hexCol = null;
        if (col == blue){
            hexCol = "[#64acff]";
        } else if (col == yellow){
            hexCol = "[#e6e75c]";
        }  else if (col == green){
            hexCol = "[#83c181]";
        }
        local test = hexCol+"aaa";
        local cellBg = UI.Canvas({
            id = "skillBg"+i
            Colour = col
            Size = VectorScreen(50,50) 
            Alpha = 40
            children = [
                UI.Sprite({
                    id = "newSpriteID"+i  
                    file = "skills/"+i+".png"
                    Alpha = 50
                    Size = VectorScreen(50,50) 
                    tooltip = {
                        direction = "down"
                        label = {
                            Text = test
                            TextColour = Colour(255,255,255)
                            FontSize =  11
                            flags = GUI_FLAG_TEXT_TAGS
                             FontFlags =  GUI_FFLAG_BOLD  
                        }, 
                        extraLabels = [
                            {
                                id = "newLabelID"  
                                Text = "labelText" 
                                move = { down = 20}
                                TextColour = Colour(255,255,255)
                            }
                        ]
                        canvasColor = Colour(51,57,61,250)
                        border = {
                            color = white
                            size = 1
                        }
                    }  
                    contextMenu = {
                        options = [
                            {
                                name =  "Buy(100)", 
                                color = Colour(255,0,0), 
                                Size = VectorScreen(60,25)
                                onClick =  function() {
                                    Console.Print("option1");
                                }
                            }
                        ]
                    }     
                })
            ]    
        })
        if (i <=5){
            g1.add(cellBg);
        } else if (i <=8){
            g2.add(cellBg);
        } else{
            g3.add(cellBg);
        }
         
    }

     local g4 = UI.Grid({
        id = "gridEqSkills"
        align = "bottom" 
        rows =1
       // background = black
        columns =3
        margin =2
        borderStyle = {
            color =black
            size = 2
        }        
    }); 

    local eqSkill1 = UI.Canvas({
        id = "eqSkill1" 
        Colour = blue
        Size = VectorScreen(50,50) 
        children = [
            UI.Sprite({
                id = "skillSpriteEq1" 
                file = "skills/1.png"
                Size = VectorScreen(50,50)
                   
            })
           
        ]    
    });
     local eqSkill2 = UI.Canvas({
        id = "eqSkill2" 
        Colour = yellow
        Size = VectorScreen(50,50) 
        children = [
            UI.Sprite({
                id = "skillSpriteEq2" 
                file = "skills/2.png"
                Size = VectorScreen(50,50)
                   
            })
           
        ]    
    });
     local eqSkill3 = UI.Canvas({
        id = "eqSkill3" 
        Colour = green
        Size = VectorScreen(50,50) 
        children = [
            UI.Sprite({
                id = "skillSpriteEq3" 
                file = "skills/3.png"
                Size = VectorScreen(50,50)
                   
            })
           
        ]    
    });
    g4.add(eqSkill1);
    g4.add(eqSkill2);
    g4.add(eqSkill3);

    local l = UI.Label({
                    id = "skillLabelCd"
                    Text = "10" 
                    TextColour = Colour(255,255,255)
                    FontSize =  16
                    FontFlags =  GUI_FFLAG_BOLD  
                    align = "center"
                });
    UI.Canvas("skillBg1").add(l);
    UI.Canvas("skillBg1").Alpha = 80;
    UI.Label("skillLabelCd").Alpha = 255;
/*
    local bg = ::Colour(50,50,50, 200);
    local pink = Colour(233,158,253);
    local white = Colour(255,255,255,150);
    local blue = Colour(100,172,255,150);
    local green = Colour(131,193,129,100);
    local yellow = Colour(230,231,92,100);

    local black =Colour(0,0,0,150);

    local wrapper = UI.Canvas({
        id = "skillGridCanvas"
        Color = bg
        Size = VectorScreen(274,264)
        align = "center" 
        autoResize = true
        children = [
            UI.Label({
                id = "skillsLabelCanvas"   
                Text = "Available Skills" 
                TextColor = pink  
                FontSize = 30
                align = "top_center"
               move =  { down =25, left = -1}
                FontName = "Arial" 
                FontFlags = GUI_FFLAG_OUTLINE | GUI_FFLAG_BOLD | GUI_FFLAG_ITALIC
            })
            UI.Sprite({
                id = "skillCanvasCloseBtn"  
                file = "decui/closew2.png" 
                Size = VectorScreen(24,24)
                align = "top_right"
                move = { down = 4, left = 6 }
              
            })
        ]    
    });
    

   local g = UI.Grid({
        id = "grid"
        align = "bottom"
        rows =3
        columns =5
        margin = 5
       // background =bg
        borderStyle = {
        //    color =white
            size = 2
        }
        onHoverOverCell = function(cell){
            //cell.Colour = ::Colour(150,200,150);
        }
        onHoverOutCell = function(cell){
           // cell.Colour = ::Colour(150,150,150);
        }
        onCellClick = function(cell){
        //    cell.Colour = ::Colour(150,150,200);
        }
        
    }); 
    for (local i = 1; i <= 13; i++ ){
        local col = i == 6 || i == 4 ? green:blue;
        if (i == 10 || i == 13){
            col = yellow;
        } 
        local cellBg = UI.Canvas({
            id = "skillBg"+i
            Colour = col
            Size = VectorScreen(50,50)    
            children = [
                UI.Sprite({
                    id = "newSpriteID"+i  
                    file = "skills/"+i+".png"
                    Size = VectorScreen(50,50)    
                })
            ]    
        })
         g.add(cellBg);
    }
    wrapper.add(g);
    wrapper.addBorders({
        color =white
        size = 3
    });
   
   

     
     g.removeLast();
      g.removeLast();
       g.removeLast();
        g.removeLast();
         g.removeLast();
          g.removeLast();
    local canvas =  UI.Canvas({
        id = ID
        Colour = Colour(100,0,0,100)
        contextMenu = { 
          
            onHide = function () {
               
             
               // ::GUI.SetFocusedElement(::UI.Canvas(ID));   
                ::Console.Print("aa");
            }
            options = [
                { 
                    name =  "Option 1",
                    color = Colour(255,0,0),
                    onClick =  function() {
                        Console.Print("option1");
                    }
                },
                { 
                    name =  "Option 2",
                    onClick =  function() {
                        Console.Print("option2"); 
                    }
                },
                {
                    name =  "Option 3",
                    onClick =  function() {
                        Console.Print("option3");
                    }
                }
            ]
        }
        children = [
            UI.Canvas({
                id = "sidebar"  
                RelativeSize = ["25%", "100%"]
                align = "top_right"
                Colour = ::Colour(255,255,255,180)    
            })
        ]
       
            
    })

    UI.Canvas("sidebar").addBorders({color = Colour(0,0,0)});
   
    Hud.RemoveFlags(HUD_FLAG_CLOCK | HUD_FLAG_WEAPON | HUD_FLAG_RADAR | HUD_FLAG_WANTED | HUD_FLAG_HEALTH |  HUD_FLAG_CASH) 
*/
}

/*
function Script::ScriptLoad(){  
    
 
  //dofile("TableDemo.nut");
  
  UI.registerKeyBind({
      name = "keyName"  
      kp= KeyBind(0x1)
      onKeyUp = function() {
           UI.Notification({
      id="not" 
      type = "info" 
      title = "INFORMATION" 
      time = 10 
      Size = VectorScreen(200, 90) 
      text = "HELLO"
  })
  UI.Notification({
      id="not2" 
      type = "success" 
      title = "SUCCESS" 
      time = 5  
       Size = VectorScreen(200, 90) 
      text = "HELLO"
  })
  UI.Notification({
      id="not3"  
      type = "warning" 
      title = "WARNING"  
      time = 10 
       Size = VectorScreen(200, 90)  
      text = "HELLO" 
  })
  UI.Notification({
      id="not4" 
      type = "error"  
      title = "ERROR" 
      time = 10  
       Size = VectorScreen(200, 90) 
      text = "HELLO"
  })
      }
      onKeyDown = function() {
          
      }
  })
  }
*/




UI.registerKeyBind({
    name = "F3"  
    kp= KeyBind(0x72)
    onKeyUp = function() {
        UI.Sprite("newSpriteID1").contextMenu = {
            options = [{
                name =  "Buy(200)", 
                color = Colour(255,0,0), 
                Size = VectorScreen(60,25)
                onClick =  function() {
                    Console.Print("option1");
                }
            }]
        }
    }
});
