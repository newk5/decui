local tv = UI.TabView({

       id="tabview",
       align = "center",
       Size = VectorScreen(400,300), 
       onTabClicked = function(t){
          //Console.Print(t +" tab clicked");
       }, 
    
       tabs = [
           {  
               title = "tab1",
               content = [ 
                    UI.Label({
                        id = "lbl"  
                        TextColour = Colour(255,255,255)
                        FontSize = 11
                        Text = "DecUI (declarative UI) is a library to create VCMP GUI's in a declarative manner. It also provides many lower level abstractions and some new components and features. All of the existing properties and functions will still work so everything listed on the VCMP wiki is still applicable. This library provides new functions and properties in addition to the current ones listed on the VCMP wiki aswell as a few new components and a declarative way of creating these components."
                        wrap = true
                        wrapOptions = {
                            lineSpacing = 7
                            wordWrap = false
                        }
                    })
                  
                   
               ]
               
           },
           { title = "tab2"  }
            { title = "tab2"  }
             { title = "tab2"  }
             { title = "tab2"  }
             { title = "tab2"  }
             { title = "tab2"  }
       ]
})

local pg = UI.Pagination({
    id = "hola" 
    Size = VectorScreen(tv.Size.X,20)
    align = "center"
    pages = 7
    onPageClicked = function (page) {
       tv.changeTab(page);
    }
});

//this is a example of how can be used with tabview
