    class Events {

        UI = null;

        constructor(ui) {
            this.UI = ui;
            
        }
  
    function onGameResize(){
       
        foreach(i,list in this.UI.lists ) { 
           foreach(c,e in list ) { 
              e.realign(); 
              if (e.rawin("shiftPos")){
                e.shiftPos(); 
              }
              if (e.rawin("onGameResize") && e.onGameResize != null){
                  e.onGameResize();
              }
            }
        }
    } 

    function onKeyUp(keybind) {
        foreach (i, kp in this.UI.kps ) {
            if (kp.kp == keybind){
                if (kp.rawin("onKeyUp") && kp.onKeyUp != null){
                    kp.onKeyUp();
                    return;
                }
            }
        }
    }

    function onKeyDown(keybind) {
        foreach (i, kp in this.UI.kps ) {
            if (kp.kp == keybind){
                if (kp.rawin("onKeyDown") && kp.onKeyDown != null){
                    kp.onKeyDown();
                    return;
                }
            }
        }
    }  

     function onListboxSelect(listbox, text){
        if (listbox.onOptionSelect!=null){
           listbox.onOptionSelect(text);  
        }
    }

    function onInputReturn(editbox) {
        if (editbox.onInputReturn!=null){
           editbox.onInputReturn();  
        }
    }

    function onScrollbarScroll(scrollbar, position,change){
        if (scrollbar.onScroll != null) {
            scrollbar.onScroll(position,change);
        }
    }

    function onClick(el, mouseX, mouseY){
        if(el.onClick!=null){
            el.onClick();
        }                           
    }

    function onFocus(el){
        try {
            if (el.tooltip.rawin("event") && el.tooltip.event == "focus"){
                el.showTooltip();
            }   
        } catch(e){

        }   
        if(el.onFocus!=null){
            el.onFocus();
        }                           
    }

    function onBlur(el){
        try {  
            if (el.tooltip.rawin("event") && el.tooltip.event == "focus"){
                el.clearTooltip();
            }   
        } catch(e){

        }  
        if(el.onBlur!=null){
            el.onBlur();
        }                           
    }

    function onCheckboxToggle(checkbox, checked){
        if(checkbox.onCheckboxToggle!=null){
            checkbox.onCheckboxToggle(checked); 
        }                           
    }

     function onWindowClose(w){
        if(w.onWindowClose!=null){
            w.onWindowClose();
        }                            
    }

    function onDrag(el,  mouseX, mouseY){
        if(el.onDrag!=null){
            el.onDrag(mouseX, mouseY);
        }                           
    }

     function onHoverOver(el){ 
          
        this.UI.hoveredEl=el;
        try {
            if (el.tooltip.rawin("event") && el.tooltip.event == "hover"){
                el.showTooltip();
            }   
        } catch(e){

        }   
        if(el.onHoverOver!=null){
            el.onHoverOver();
        }
                                 
    }

    function onRelease(el,  mouseX, mouseY){
        if(el.onRelease!=null){
            el.onRelease(mouseX, mouseY);
        }                           
    }

    function onHoverOut(el){
        try {  
            if (el.tooltip.rawin("event") && el.tooltip.event == "hover"){
                el.clearTooltip();
            }   
        } catch(e){
 
        }  
      
        if(el.onHoverOut!=null){
            el.onHoverOut();
        }                            
    }

    function scriptProcess(){
       if (this.UI.toDelete != null) {
           Timer.Process();
            foreach (i, e in this.UI.toDelete ) {
                this.UI.toDelete.remove(i);
                e = null;
            }
       }
   } 
}