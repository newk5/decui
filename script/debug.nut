
    function stringArray(a) {
        local str  = a.reduce(function(previousValue, currentValue){
            return (previousValue +","+ currentValue);
        });
        if (str == null) return "[ ]";
        return "[ "+str+" ]";
    }

    function printVectorScreen(v, pref="") {
        Console.Print(pref+"VectorScreen{ X="+v.X+", Y="+v.Y+" }");
    }

    function showDebugUI() {

        UI.showDebugInfo=true;
        UI.excludeDebugIds=true;
        foreach (name in UI.names) {
            UI.newData(name,0);
        }


        local c = UI.Canvas({
            id = "decui:debug:debugCanvas"
            align="bottom_right"
            Color= Colour(150,150,150,100)
            border = {}
            Size = VectorScreen(230, GUI.GetScreenSize().Y-200),
            onGameResize = function () {
                this.Size.Y = GUI.GetScreenSize().Y-200;
                this.realign();
                this.updateBorders();
            }
        })
        local y = 20;
        foreach (name in UI.names) {


        local b= UI.Button({
                id = "decui:debug:showBtn:"+name
                Text = "show"
                Size = VectorScreen(30, 20)
                elementData = { list=name}
                Position = VectorScreen(10, y+4)
                onClick = function() {
                    local tbl = UI.DataTable("decui:debug:DebugTable");
                    if (tbl!=null){
                        tbl.destroy();
                    }
                    local opts = [];

                    foreach (el in UI.getList(this.elementData.list)) {
                        local p = el.getParent();
                        if (!UI.excludeDebugIds){
                            opts.push({id=el.id, parent=p == null ? "":p.id});
                        }else{
                            if (el.id.find("decui:debug")==null){
                                opts.push({id=el.id, parent=p == null ? "":p.id});
                            }
                        }

                    }
                    local w = UI.Window("decui:debug:window");
                    if (w !=null){
                        w.destroy();
                    }
                    local canvas = UI.Canvas("decui:debug:debugCanvas");
                    local listName = this.elementData.list;
                    UI.Window({
                        id = "decui:debug:window"
                        Size = VectorScreen(750,400)
                        align="center"
                        elementData= {list = listName}
                        Color = ::Colour(49,55,59,255)
                        move={right="18%"}
                        Text="W"
                        postConstruct = function(){
                            UI.DataTable("decui:debug:DebugTable").realign();
                            this.Text = this.elementData.list +" ID's";
                        }
                        children = [
                            UI.DataTable({
                                id = "decui:debug:DebugTable"
                                align="center"
                                rows = 10
                                columns = [
                                    { header = "ID", field = "id"},
                                    { header = "Parent", field = "parent"}
                                ]
                                data =opts
                            })
                        ]
                    })




                }
            })
            c.add(b);
        local lName=  UI.Label({
            id = "decui:debug:label:"+name+":name"
            FontSize= 16
            Text = name+": "
            Position = VectorScreen(35, y)
        });
        c.add(lName);
        local l=  UI.Label({
            id = "decui:debug:label:"+name
            Text = "0"
            FontSize= 16
            bindTo=name
            Position = VectorScreen(150, y)
        });
        c.add(l);
            y +=25;



        }
    }

    function stringArrayWithIds(a) {
        try {
        local str  = a.reduce(function(previousValue, currentValue){
            return (previousValue.id +","+ currentValue.id);
        });

        if (str == null) return "[ ]";
        return "[ "+str+" ]";
        } catch( ex){
            Console.Print(ex);
        }
    }

    function printTable(t){

        foreach (i,k in t){
           //Console.Print(t[k]);
            Console.Print("{ "+i+"="+k+" }");
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

    function showCreatedElements(){
       Console.Print("-----------------------------------------------------------------")

         foreach (i, s in UI.names) {
            if (UI.lists[i].len()>0)
                Console.Print(s +" --> "+UI.lists[i].len());
        }
    }

    function printList(l){
       Console.Print("----------------------CANVAS START-------------------------------------------")

         foreach (i, s in UI.lists[UI.names.find(l)] ) {

            Console.Print(s.id);
        }
          Console.Print("----------------------CANVAS END-------------------------------------------")
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
                        UI.Canvas(this.data.id).addBorders({ color = ::getroottable().Colour(255,0,0), size = 2 });
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