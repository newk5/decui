dofile("debug.nut")
dofile("decui/decui.nut");



COL_TEXT <- Colour(255, 255, 255);
COL_TEXTBG <- Colour(20, 20, 20);
COL_SCROLL <- Colour(50, 50, 50);
COL_WINDOW <- Colour(75,75,75);
COL_TITLEBAR <- Colour(10,10,10);
CONSOLE_ALPHA <- 192;

CONSOLE_FONT <- "Lucida Console";
WINDOW_FONT <- "Verdana";
TITLEBAR_FONT <- "Tahoma";

w <- 400;
h <- 500;
 
window <- null;
button <- null;
editbox <- null;
memobox <- null;
 
PLAYER_POS <- Vector(-1002.2512, 197.51759, 24);



function Debug::ClientData(stream) {
      
    local type = stream.ReadInt();
   Console.Print("------->"+type);
    if (type == 0){
        local s = Stream();
        s.WriteInt(0);
        s.WriteInt(32);
        Debug.SendData(s); 
    }

   
}

function Server::ServerData(s){
    local type = s.ReadInt();
    UI.processStream(type, s);
    Console.Print("aaaaaaaaaaaaaaaaaaaaaaa" +type); 
} 

columns <- [
         { header = "ID", field = "id"},
         { header = "Name", field = "name" },
         { header = "RSpawns", field = "rspawns" },
         { header = "BSpawns", field = "bspawns" }
       
    ] 

function Script::ScriptLoad(){

     UI.Cursor("ON"); 
    local leftPanel = UI.Canvas({
        id = "leftPanel"  
        RelativeSize = [ "45%", "100%" ]
        children = [ 
            UI.Label({
                id = "newLabelID"  
                Text = "labelText" 
                align = "top_right"
                move = { down = "15%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
                
               
            })
             UI.Label({
                id = "newLabelID2"  
                Text = "labelText2" 
                align = "top_right"
                move = { down = "20%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
               
            })
             UI.Label({
                id = "newLabelID3"  
                Text = "labelText3" 
                align = "top_right"
                move = { down = "25%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
               
            })
             UI.Label({
                id = "newLabelID4"  
                Text = "labelText4" 
                align = "top_right"
                move = { down = "30%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
                
            })
        ]
           
    });
    leftPanel.addBorders({})
 //   Console.Print(UI.Label("newLabelID").metadata.ORIGINAL_POS.X);
    local l5 =  UI.Label({
                id = "newLabelID5"  
                Text = "labelText5" 
                align = "top_left"
                move = { down = "15%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
               
            });
     local l6 =  UI.Label({
                id = "newLabelID6"  
                Text = "labelText6" 
                align = "top_left"
                move = { down = "20%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
               
            });
     local l7 =  UI.Label({
                id = "newLabelID7"  
                Text = "labelText7" 
                align = "top_left"
                move = { down = "25%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
               
            });    
    local l8 =  UI.Label({
                id = "newLabelID8"  
                Text = "labelText8" 
                align = "top_left"
                move = { down = "30%" }
                TextColour = Colour(255,0,0)
                FontSize = 22
               
    });             
    local rightPanel = UI.Canvas({
        id = "rightPanel"
        align = "top_right"  
        RelativeSize = [ "45%", "100%" ]
        
           
    })
rightPanel.add(l5);
rightPanel.add(l6);
rightPanel.add(l7);
rightPanel.add(l8);

    
    rightPanel.addBorders({}); 
   
    
  // Server.ServerData(); 
  //  UI.Cursor("off"); 
  //  dofile("TableDemo.nut"); 
    UI.registerKeyBind({ 
        name = "M"   
        kp= KeyBind(0x4D)
        onKeyUp = function() {
            //::UI.DataTable("tbl").setPage(3);
            local o = { col1 = "val2", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"};
            ::UI.DataTable("tbl").addRow( o);
            ::addData(o)
        }
        onKeyDown = function() {
              
        }  
    }) 
    
      UI.registerKeyBind({ 
        name = "N"   
        kp= KeyBind(0x4E)
        onKeyUp = function() {
            
           // ::UI.DataTable("tbl").setPage(4);
          //  local o = { col1 = "val2", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"};
           // ::UI.DataTable("tbl").addRow( o);
           // ::addData(o)
        }
        onKeyDown = function() {
            
        } 
    }) 
     UI.registerKeyBind({ 
        name = "H"  
        kp= KeyBind(0x48)
        onKeyUp = function() {
            ::UI.DataTable("tbl").setPage(3);
          //  local o = { col1 = "val2", col2 = "1a4124124", col3 = "val3", col4 = "val4", col5 = "val5"};
           // ::UI.DataTable("tbl").addRow( o);
           // ::addData(o)
        }
        onKeyDown = function() {
            
        }
    }) 
    
   
    //UI.Cursor("off")*/
/*
     UI.Scrollbar({
        id = "scrollBarID"
        ContentSize = 100
        BarSize = 0.1 
     //   BarPosition = 1
       // BackgroundShade = "10"  
        StepSize = 5
        //BarColour = Colour(0,2,25)
        Position = VectorScreen(500,0)
        Colour = ::Colour(0,150,0) 
        Size = VectorScreen(20,300)
      //  flags = GUI_FLAG_SCROLLABLE
    })
    */
    //dofile("ComboboxDemo.nut") 
  
} 


function new(){
     local ww=  UI.Window({ 
        id = "windowID"  
        Position = VectorScreen(75, 75)
        Size = VectorScreen(h,w),
        Text = "[#22ff22]MGUI[#d] Test Console"
        flags = GUI_FLAG_TEXT_TAGS  | GUI_FLAG_3D_ENTITY
        FontFlags = GUI_FFLAG_BOLD
        TitleColour = Colour(10,10,10)
        Transform3D = { 
            Position3D = PLAYER_POS
            Rotation3D = Vector(-1.5, 0.0, 0)
            Size3D = Vector(1, 1, 0.0)

        }
        children = [
            UI.Button({
                id = "newButtonID"  
                Text = "Submit" 
                align = "bottom_right"
                flags = GUI_FLAG_BORDER
                move = {left = "3%", up= "2%"}
                onClick = function() {
                    
                }
            })
            UI.Editbox({
                id = "editBoxID"  
                align = "bottom_left",
                move = { up = "2%", right = 10}
                Size = VectorScreen(420, 22),
                flags  = GUI_FLAG_NONE | GUI_FLAG_VISIBLE

            }),
            UI.Memobox({
                id = "memoboxID"  
                Size =  VectorScreen(500, 330)
              //  Position = VectorScreen(12, 10)
                flags = GUI_FLAG_MEMOBOX_TOPBOTTOM | GUI_FLAG_TEXT_TAGS | GUI_FLAG_SCROLLABLE | GUI_FLAG_SCROLLBAR_HORIZ
                TextColour = COL_TEXT
                FontName = CONSOLE_FONT
                FontSize = 10
                TextPaddingTop = 10
                TextPaddingBottom = 4
                TextPaddingLeft = 10
                TextPaddingRight = 10
            })
        ]
    })  
    UI.Memobox("memoboxID").AddLine("hlloeee")

}

function normal() {
     ::window = GUIWindow(VectorScreen(75, 75), VectorScreen(w, h), COL_WINDOW, "", GUI_FLAG_TEXT_TAGS);
    ::window.AddFlags(GUI_FLAG_VISIBLE | GUI_FLAG_DRAGGABLE | GUI_FLAG_WINDOW_RESIZABLE | GUI_FLAG_WINDOW_TITLEBAR);

    ::window.FontName = TITLEBAR_FONT;
    ::window.FontSize = 10;
    ::window.FontFlags = GUI_FFLAG_BOLD;
    ::window.Text = "[#22ff22]MGUI[#d] Test Console";
    ::window.TitleColour = COL_TITLEBAR;
    ::window.Alpha = CONSOLE_ALPHA;

    // Submit button
    ::button = GUIButton(VectorScreen(w - 65, h - 56), VectorScreen(50, 22), COL_WINDOW, "Submit", GUI_FLAG_BORDER | GUI_FLAG_VISIBLE);
    ::button.TextColour = COL_TEXT;
    ::button.FontName = WINDOW_FONT;
    ::button.FontSize = 11;
    ::window.AddChild(button);

    // Editbox
    ::editbox = GUIEditbox(VectorScreen(12, h - 56), VectorScreen(w - 86, 22), COL_TEXTBG, "", GUI_FLAG_NONE | GUI_FLAG_VISIBLE);
    ::editbox.TextColour = COL_TEXT;
    ::editbox.FontName = CONSOLE_FONT;
    ::editbox.FontSize = 11;
    ::window.AddChild(editbox);

    // Memobox (actual console part)
    ::memobox = GUIMemobox(VectorScreen(12, 10), VectorScreen(w - 24, h - 74), COL_TEXTBG, GUI_FLAG_MEMOBOX_TOPBOTTOM | GUI_FLAG_VISIBLE);
    ::memobox.TextColour = COL_TEXT;
    ::memobox.FontName = CONSOLE_FONT;
    ::memobox.FontSize = 10;
    ::memobox.AddFlags(GUI_FLAG_TEXT_TAGS | GUI_FLAG_SCROLLABLE | GUI_FLAG_SCROLLBAR_HORIZ);
    ::memobox.TextPaddingTop = 10;
    ::memobox.TextPaddingBottom = 4;
    ::memobox.TextPaddingLeft = 10;
    ::memobox.TextPaddingRight = 10;
    ::window.AddChild(memobox);

    ::memobox.AddLine("[#22ff22]MGUI[#e] test console loaded!");
    ::memobox.AddLine("Using [#ff0000][#uline]DirectX8[#e] renderer.");

    ::window.AddFlags(GUI_FLAG_3D_ENTITY);
    ::window.Set3DTransform(PLAYER_POS, Vector(-1.6, 0.0, 0), Vector(2, 2, 0.0));
}



 