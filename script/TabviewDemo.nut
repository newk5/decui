local tv = UI.TabView({

       id="tabview",
       align = "center",
       Size = VectorScreen(400,300), 
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
                       Text = "Add tab"
                      
                   })
                    UI.Button({ 
                       id="btnrm",
                       Size = VectorScreen(60, 20),
                       onClick= function(){
                           local tv = UI.TabView("tabview");
                           if (tv.tabs.len() > 0) {
                                tv.removeTab(tv.tabs.len()-1);
                           }
                          
                       },
                       Text = "Delete tab",
                       move = {down = 20, right = 20}
                   })
                   
               ]
               
           },
           { title = "tab2"  }
          
       ]
}); 

