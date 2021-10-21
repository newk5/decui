class Combobox extends DecUIComponent {

    className = "Combobox";

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

    isOpen = null;
    labelColour = null;
    colour = null;

    height =  null;
    border =null;

    bindTo=null;
    bindToValue= null;



    constructor(o) {
        base.constructor(o);
        this.isOpen = false;
        this.options = o.rawin("options") ? o.options : [];
        if (o.rawin("bindTo") && o.bindTo != null){
            ::UI.store.attachIDAndType(o.bindTo,o.id, "Combobox");
            local val =  ::UI.store.get(o.bindTo);
            this.options = val;
            this.bindTo = o.bindTo;
        }

        this.colour = ::Colour(255,255,255);
        this.labelColour = ::Colour(0,0,0);
        this.onOptionSelect = o.onOptionSelect;
        if (o.rawin("value") && o.value != null){
            this.value =o.value;
        }else{
             this.value = "Select";
        }

          if (o.rawin("bindToValue") && o.bindToValue != null){
            this.bindToValue = o.bindToValue;
            ::UI.store.attachIDAndType(o.bindToValue,o.id, "Combobox", true);
            local val =  ::UI.store.get(o.bindToValue);
            this.value = val;
        }

        if (o.rawin("size") && o.size != null){
            this.size =o.size;
        }
        if (o.rawin("Colour") && o.Colour != null){
            this.colour =o.Colour;
        }
        if (o.rawin("labelColour") && o.labelColour != null){
            this.labelColour =o.labelColour;
        }
        if (this.options != null){
            calcHeigh =this.calculateListHeight();
        }

        if (o.rawin("height")){
            this.height = o.height;

        }
        if (o.rawin("elementData")){
            this.elementData = o.elementData;
        }else{
            this.elementData = {};
        }
          if (o.rawin("border")){
            this.border = o.border;

        }




        this.arrowSpriteID = this.id+"::ComboBox::ArrowSprite";
        this.listboxID = this.id+"::ComboBox::lstBox";
        this.labelID = this.id+"::ComboBox::label";

        this.canvasSize = VectorScreen(this.size == null ? 90: this.size,this.height == null ? 20: this.height);



        this.build(null,  this.onOptionSelect);

    }



   function addBorders(o) {
       UI.Canvas(this.id).addBorders({})
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
        ::getroottable().UI.openCombo =  { id =this.id, list = "canvas" };
          this.isOpen=true;

        local c = ::UI.Canvas(this.id);
        local lst = UI.Listbox(this.listboxID);
        if (c.parents.len() > 0) {
            local maxPos = lst.Size.Y+c.Position.Y+c.Size.Y;
            local maxPosX = lst.Size.X+c.Size.X;
            local parent =UI.Canvas(c.parents[0]);
            if (parent == null){
                return;
            }
            if (parent.Size.Y < maxPos){
                parent.Size.Y = maxPos;
                parent.updateBorders();
            }
             if (parent.Size.X < maxPosX){
                parent.Size.X = maxPosX;
                parent.updateBorders();
            }
        }
    }

    function hidePanel(){

        ::getroottable().UI.Listbox(this.listboxID).hide();
        ::getroottable().UI.Canvas(this.id).Size.Y = 20;
        ::getroottable().UI.openCombo = null;
        this.isOpen=false;
        local c = ::UI.Canvas(this.id);
        if (c.parents.len() > 0) {
            local parent =UI.Canvas(c.parents[0]);
            if (parent == null){
                return;
            }
            parent.Size.Y =  c.Position.Y+c.Size.Y+7;
            parent.updateBorders();
        }
    }


    function setText(text, triggerEvent = true){
        UI.Label(this.labelID).set("Text",text);
        if (this.onOptionSelect != null && triggerEvent){
            this.onOptionSelect(text);

        }

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
                TextColour = labelColour
                align = "mid_left"
                move = { right = 5}
                parents = childParents,
                onClick = function(){

                    if (context.isOpen){
                        context.hidePanel();

                    }else{
                         local listbox = UI.Listbox(context.listboxID);
                        listbox.Size.Y =90;
                        local c = UI.Canvas(context.id);
                        c.Size.Y = 118;
                        context.showPanel();

                       // GUI.SetFocusedElement(UI.Listbox(this.context.listboxID))
                        listbox.SendToTop();

                    }
                }
        });

        local sprite =  UI.Sprite({
                    id=this.arrowSpriteID,
                    file ="decui/down.png",
                    context = this,
                    Size =VectorScreen(16,16),
                   align="top_right",
                    parents = childParents,
                    move = {down = "22%", left=3 },
                    onClick = function(){

                        if (context.isOpen){
                            context.hidePanel();

                        }else{
                             local listbox = UI.Listbox(context.listboxID);
                            listbox.Size.Y =90;
                            local c = UI.Canvas(context.id);
                            c.Size.Y = 118;
                            context.showPanel();

                        }

                    }
        });

        local listbox =  UI.Listbox({
                    id=this.listboxID,
                    context = this,
                    Alpha = 150,
                    parents = childParents,
                    Position = VectorScreen(0, this.height== null ? 20: this.height),
                    Colour = this.colour
                    TextColour = this.labelColour
                    Size = VectorScreen(90,42),
                    options = this.options,
                    onOptionSelect = function(option){
                        context.hidePanel();
                        ::getroottable().UI.Canvas(context.id).Size.Y = context.canvasSize.Y;
                        local label = ::getroottable().UI.Label(context.labelID);
                        label.set("Text", option) ;
                        label.Position.Y = 2;

                        context.value = option;
                        if (optionSelect != null){
                            context.isOpen = false;
                            optionSelect(option);

                        }
                    },
                    postConstruct = function() {
                        this.Size.X= context.canvasSize.X;
                        this.hide();
                    }
                });
        listbox.AddFlags(GUI_FLAG_SCROLLABLE );
        childParents.push(this.id);
        local c = UI.Canvas({
            id=this.id,
            presets = this.presets
            context = this,
            align = this.align
            Size = this.canvasSize ,
            Color= this.colour,
            Position = this.Position,
            flags = GUI_FLAG_MOUSECTRL,
            parentSize = this.parentSize,
            move = this.move
            parents =parentsList,
            elementData = this.elementData
            onClick = function(){

                if (context.isOpen){
                    context.hidePanel();

                }else{
                     local listbox = UI.Listbox(context.listboxID);
                    listbox.Size.Y =90;
                    local c = UI.Canvas(context.id);
                    c.Size.Y = 118;
                    //listbox.Position.Y = c.Size.Y+15;
                    context.showPanel();


                }
            },

        });
        //;
        if (this.border != null) {
            c.addBorders(this.border)
        }
        //



        c.add(label, false);
        c.add(sprite, false);
        c.add(listbox, false);

        sprite.resetMoves();
        sprite.realign();
        sprite.shiftPos();
        c.realign();
        return c;



    }
    function size(){
        return this.options.len();
    }

    function addItem(item, triggerBind = true){


        local c = ::getroottable().UI.Listbox(this.listboxID);
        if (c != null){

            c.AddItem(item);
            this.options.push(item);

             if (this.bindTo != null && triggerBind){
                ::getroottable().UI.pushData(this.bindTo, item , true);
            }


        }

    }

     function removeItem(item, triggerBind = true){
        local idx = this.options.find(item);
        local c = ::getroottable().UI.Listbox(this.listboxID);
        if (c != null){

            c.RemoveItem(item);
            if (idx != null) {

                this.options.remove(idx);
                 if (this.bindTo != null && triggerBind){
                    UI.popData(this.bindTo, idx, true);
                }
            }
        }

    }

    function clear( triggerBind = true){
        local c = ::getroottable().UI.Listbox(this.listboxID);
        if (c != null) {
            c.Clean();
            this.options.clear();
             if (this.bindTo != null && triggerBind){
                UI.setData(this.bindTo, options, true);
            }
        }
    }

    function Clean(){
        this.clear();
    }

    function setOptions(options, triggerBind = true) {
        local c = ::getroottable().UI.Listbox(this.listboxID);
        if (c != null) {
            c.Clean();
            this.options =options;
            foreach (i,item in options) {
                c.AddItem(item);
            }
            if (this.bindTo != null && triggerBind){
                UI.setData(this.bindTo, options, true);
            }
        }

    }


}

UI.registerComponent("ComboBox", {
    create = function(o) {
        local c = Combobox(o);
        return c;

    }
});