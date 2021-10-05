local tv = UI.TabView({

       id="tabview",
       align = "center",
       Size = VectorScreen(400,300),
       move = { left = "10%"}
       onTabClicked = function(t){
          Console.Print(t +" tab clicked");
       },

       tabs = [
           {
               title = "tab1",
               content = [
                    UI.Label({
                        id = "lblt"
                        TextColour = Colour(255,0,0)
                        Text = "TestttttttttttttttttasdasasdaddsdadasdttttAAAAAAA123 111 222 333 444 555 666 777 888 999"
                        wrap = true
                        wrapOptions = {
                            lineSpacing = 5

                        }

                    })
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

