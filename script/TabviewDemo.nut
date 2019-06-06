


local tv = UI.TabView({

       id="tabview",
       align = "center",
       size = VectorScreen(400,300), 
       onTabClicked = function(t){
          Console.Print(t +" tab clicked");
       }, 
    
       tabs = [
           {  
               title = "tab1",
               content = [ 
                 
                   UI.Button({   
                       id="btrn",
                       align = "center",
                       Size = VectorScreen(60, 20), 
                       onClick= function(){
                           local tv =UI.TabView("tabview");
                           tv.addTab({ title = "tab"+(tv.tabs.len()+1) });
                       },
                       Text = "Add tab",
                       move = {down = 40, right = 20}
                      
                   })
                    UI.Button({
                       id="btnrm",
                       Size = VectorScreen(60, 20),
                       onClick= function(){
                           local tv = UI.TabView("tabview");
                           tv.removeTab(tv.tabs.len()-1);
                       },
                       Text = "Delete tab",
                       move = {down = 20, right = 20}
                   })
               ]
              
           },
           { title = "tab2"  }
          
       ]
}); 

