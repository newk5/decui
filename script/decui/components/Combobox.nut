class Combobox extends Component {
   
    className = null;
    id = null;
    options = null;
    value = null; 
    onOptionSelect = null;
    arrowSpriteID= null;
    listboxID = null;
    labelID = null;  
    parentSize = null;
    size = null; //horizontal size
    canvasSize = null;
    calcHeigh = null; // size height calculated from the total options in the combobox
    Position = null;

    constructor(o) {
        this.className = "Combobox"; 
       
        this.id = o.id; 
        this.options = o.options; 
        this.onOptionSelect = o.onOptionSelect;
        if (o.rawin("value") && o.value != null){
            this.value =o.value;
        }else{
             this.value = "Select";
        }
        if (o.rawin("size") && o.size != null){
            this.size =o.size;
        }
        if (this.options != null){
            calcHeigh =this.calculateListHeight();
        }

        if (o.rawin("Position") && o.Position != null){
            this.Position = o.Position;
        }else{
            this.Position = VectorScreen(0,0);
        }

        this.arrowSpriteID = this.id+"::ComboBox::ArrowSprite";
        this.listboxID = this.id+"::ComboBox::lstBox";
        this.labelID = this.id+"::ComboBox::label";
        this.canvasSize = VectorScreen(this.size == null ? 90: this.size, 20);

         base.constructor(this.id);
        this.build(null,  this.onOptionSelect);
        
    } 
 
 
   function calculateListHeight() {
        calcHeigh =  (21 * this.options.len()) +20 ; 
        return calcHeigh;
    }

    function attachParent(parent){
         this.parentSize = parent.Size;
 
         local c = ::getroottable().UI.Canvas(this.id);
       
        parent.AddChild(c);
        c.parentSize = this.parentSize;
        local parents = parent.parents;
        parents.push(parent.id);
        c.parents = parents;
        
        c.shiftPos();
        c.realign();
     
    }

    function setSize(s) {

        local c = ::getroottable().UI.Canvas(this.id);
        if (c != null){
            c.Size.X = s;
            canvasSize.Size.X = s;

            local lst = ::getroottable().UI.Listbox(this.listboxID);
            if (lst != null){
                list.Size.X = s;
            }
        }
    }

    function showPanel(){

        ::getroottable().UI.Listbox(this.listboxID).show();
        ::getroottable().UI.Canvas(this.id).Size.Y = this.calculateListHeight();
        ::getroottable().UI.openCombo = ::getroottable().UI.Canvas(this.id);  
    }

    function hidePanel(){
        ::getroottable().UI.Listbox(this.listboxID).hide();
        ::getroottable().UI.Canvas(this.id).Size.Y = 20;
        ::getroottable().UI.openCombo = null;  
    }
 
    function build(parent, optionSelect){
        
        if (parent != null){
            this.parentSize = parent.Size;
        } else{
            this.parentSize = GUI.GetScreenSize();
        }
        local parentsList =parent == null ? [] : parent.parents;
        if (parent != null) {
            parentsList.push(parent.id);
        }
        local childParents = [];
        foreach (idx, p in parentsList) { 
            childParents.push(p);
        }


        local label = UI.Label({
                id =this.labelID,
                context = this,
                Text = this.value,
                parents = childParents,  
                onClick = function(){ 
                   context.showPanel();
                }         
        });

        local sprite =  UI.Sprite({
                    id=this.arrowSpriteID,
                    file ="decui/down.png", 
                    context = this,  
                    Size =VectorScreen(16,16),
                    align="top_right",
                    parents = childParents,
                    move = {down = 1, left = 2 },
                    onClick = function(){
                        context.showPanel();
                    }
        });

        local listbox =  UI.Listbox({
                    id=this.listboxID,
                    context = this,
                    Alpha = 255, 
                    parents = childParents, 
                    Position = VectorScreen(0, 19),
                    Size = VectorScreen(90,42), 
                    options = this.options,
                    onOptionSelect = function(option){
                        this.hide();
                        ::getroottable().UI.Canvas(context.id).Size.Y = 20;
                        local label = ::getroottable().UI.Label(context.labelID);
                        label.Text = option;
                        context.value = option;
                        if (optionSelect != null){
                            optionSelect(option);
                        }
                    },
                    postConstruct = function() {
                        this.Size.X= context.canvasSize.X;
                        this.hide();
                    }
                }); 

        childParents.push(this.id);
        local c = UI.Canvas({
            id=this.id,
            context = this,
            Size = this.canvasSize ,
            Color= Colour(255,255,255,255),   
            Position = this.Position,
            flags = GUI_FLAG_MOUSECTRL,
            parentSize = this.parentSize, 
            parents =parentsList,
            onClick = function(){
                 context.showPanel();
            },
            
        }) 
        c.addChild(label);
        c.addChild(sprite);
        c.addChild(listbox);  

        sprite.realign();
        //printElementData(sprite);
        return c;

       
        
    }
    function size(){
        return this.options.len();
    }

    function addItem(item){
        if (this.options.find(item)== null){
            local c = ::getroottable().UI.Listbox(this.listboxID);
            if (c != null){
                c.AddItem(item);
                this.options.push(item);
            }
        }
    }

     function removeItem(item){
        local idx = this.options.find(item);
        local c = ::getroottable().UI.Listbox(this.listboxID);
        if (c != null){
            c.RemoveItem(item);
            if (idx != null) {
                this.options.remove(idx); 
            }
        }
        
    }

    function clear(){
        local c = ::getroottable().UI.Listbox(this.listboxID);
        if (c != null) {
            c.Clean();
            this.options.clear();
        }
    }
    

 
}