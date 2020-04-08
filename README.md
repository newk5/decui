# DecUI
DecUI (declarative UI) is a library to create VCMP GUI's in a declarative manner. It also provides many lower level abstractions and some new components and features.
All of the existing properties and functions will still work so everything listed on the [VCMP wiki](http://wiki.vc-mp.org/wiki/Scripting/Squirrel/Client_Functions#GUI_Functions
) is still applicable. This library provides new functions and properties in addition to the current ones listed on the VCMP wiki aswell as
a few new components and a declarative way of creating these components. 

# Usage

+ Download the zipped file from [here](https://github.com/newk5/decui/releases)
+ Extract the contents of the **script** folder to your **store/script/** directory
+ Extract the contents of the **sprites** folder to your **store/sprites/** directory (if you don't have this directory, create it)
+ At the top of your **main.nut** file import the library by using:
```javascript
dofile("decui/decui.nut"); 
```
+ And that's all 

___


### Important note

*One important thing to note is that your main.nut file should only have one GUI event and that's Script::ScriptLoad(). You shouldn't have other GUI:: events or KeyBind:: events there or else these will override DecUI's events and it won't work propertly. If you really need to have other GUI:: events on your main.nut file, you will have to manually bind them to DecUI like this:* 

```javascript
function KeyBind::OnDown(keyBind) {
    UI.events.onKeyDown(keyBind);
}
function GUI::ElementHoverOut(element){
    UI.events.onHoverOut(element);
}
function GUI::ElementClick(element, mouseX, mouseY){
    UI.events.onClick(element,mouseX,mouseY); 
} 
 //etc...
```
You can see a list of all the events you have to bind [here](https://github.com/newk5/decui/blob/master/script/decui/decui.nut#L20)

# Comparison

The following is a canvas centered horizontally and vertically on the screen, with a button also centered inside the canvas 
with a label and an editbox. You can type on the editbox and click the button to change the label's text. 

![Alt Text](https://i.imgur.com/5l3gbAs.gif)

Below is a comparison of how
the code for this would look like when using the imperative VCMP based approach and with the declarative approach using DecUI:

### Imperative approach
```javascript
canv <- null;
btn <- null;
input <- null;
lbl <- null;


function Script::ScriptLoad(){

     GUI.SetMouseEnabled(true);

    ::canv = GUICanvas();
    canv.Size = VectorScreen(350,200);
    canv.Position = VectorScreen(GUI.GetScreenSize().X/2-canv.Size.X/2,GUI.GetScreenSize().Y/2 -canv.Size.Y/2);
    canv.Color = Colour(150,150,150,250); 

    local btnSize =VectorScreen(100,30);
    ::btn = GUIButton( VectorScreen(canv.Size.X/2-btnSize.X/2,canv.Size.Y/2 -btnSize.Y/2),btnSize, Colour(255,0,0), "Change label");

    ::input = GUIEditbox(VectorScreen(125,30), VectorScreen(100,20), Colour(255,255,255), "This is a label");

    ::lbl =GUILabel(VectorScreen(135,135), Colour(0,0,0), "This is a label");

    canv.AddChild(btn);
    canv.AddChild(input);
    canv.AddChild(lbl);
    
}

function GUI::ElementClick(element, mouseX, mouseY){
   if (element == btn){
       lbl.Text = input.Text;
   }
} 

function GUI::ElementHoverOver(element) {
     if (element == btn){
       btn.Colour = Colour(0,150,0);
   }
}
function GUI::ElementHoverOut(element){
    if (element == btn){
       btn.Colour = Colour(220,0,0)
   }
}
```


### Declarative approach (using DecUI)
```javascript
dofile("decui/decui.nut"); //import the library

function Script::ScriptLoad(){

    UI.Cursor("ON"); 
  
    UI.Canvas({
        id = "canv"
        Size =VectorScreen(350,200)
        align = "center"
        Color = Colour(150,150,150,250)
        children = [
            UI.Button({
                id      ="btn"
                align   = "center"
                Size    = VectorScreen(100,30)
                Colour  = Colour(220,0,0)
                Text    = "Change label"
                onClick = function() {
                    UI.Label("lbl").Text = UI.Editbox("input").Text;
                }
                onHoverOver = function() {
                   this.Colour = ::Colour(0,150,0);
                }
                onHoverOut  = function() {
                    this.Colour =::Colour(220,0,0);
                }
            })
             UI.Editbox({
                id       = "input"
                Position = VectorScreen(125,30)
                Size     = VectorScreen(100,20)
                Colour   = Colour(255,255,255)
                Text     = "This is a label"
            })
            UI.Label({
                id       = "lbl"
                Text     = "This is a label"
                Position = VectorScreen(135,135)
                Color    = Colour(0,0,0)
            })
        ]
    })
    
}
```
The declarative approach is more readable and does not require you to create any global variables or any other functions.
