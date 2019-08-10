    class Events {


            UI = null;

            constructor(ui) {
                this.UI = ui;

            } 
    
        function onGameResize(){

            foreach(i,list in this.UI.lists ) { 
               foreach(c,e in list ) { 
                   if (e.parents.len() == 0){

                 
                        if (e.rawin("RelativeSize") && e.RelativeSize != null && e.RelativeSize.len() > 0){

                            ::UI.applyRelativeSize(e); 
                            e.resetPosition();
                            e.realign();
                            if (e.rawin("shiftPos") && e.shiftPos != null){
                                e.shiftPos(); 
                            } 
                            e.updateBorders();
                           
                        }else{

                            e.resetPosition();
                            e.realign();  
                            if (e.rawin("shiftPos") && e.shiftPos != null){
                                e.shiftPos(); 
                            }
                                
                                
                        }

                        foreach (idx, child in e.getChildren() ){
                            child.resetPosition();
                            child.realign();  
                            if (child.rawin("shiftPos") && child.shiftPos != null){
                                child.shiftPos(); 
                            }
                            if (child.rawin("onGameResize") && child.onGameResize != null){
                                child.onGameResize();
                            }
                        }
                        if (e.rawin("onGameResize") && e.onGameResize != null){
                            e.onGameResize();
                        }
                    }
                 
                  
                  
                 
                 
                }
            }
        } 

        function onWindowResize(window, width, height){
            if (window.onWindowResize != null){
                window.onWindowResize(width, height);
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
            if(el.onClick!=null && el != null){
               UI.lastClickedEl = { id = el.id, list = el.metadata.list };
                if ( (!el.rawin("context") || el.context == null) &&  UI.openCombo != null){
                   
                    local c = UI.Canvas(UI.openCombo.id);
                    if (c !=null) {
                        c.context.hidePanel();
                    }
                }
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

            this.UI.hoveredEl= { id =el.id, list = el.metadata.list };
            try {
                if (el.tooltip != null){
                    local isString = (typeof el.tooltip ) == "string";
                    local doesNotSpecifyEvent = isString ? true : !el.tooltip.rawin("event");
                    local eventIsNotFocus = !doesNotSpecifyEvent ? el.tooltip.event != "focus" : true;
                    
                    if (isString || doesNotSpecifyEvent || eventIsNotFocus) {
                        el.showTooltip();
                    }
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
                 this.UI.hoveredEl=null;
                if (el.tooltip != null){
                    local isString = (typeof el.tooltip ) == "string";
                    local doesNotSpecifyEvent = isString ? true : !el.tooltip.rawin("event");
                    local eventIsNotFocus = !doesNotSpecifyEvent ? el.tooltip.event != "focus" : true;
                    if (isString || doesNotSpecifyEvent || eventIsNotFocus) {
                        el.clearTooltip();
                    }
                }   
            } catch(e){
                //Console.Print(e);
            }   

            if(el.onHoverOut!=null){
                el.onHoverOut();
            }                            
        }  

        function scriptProcess(){
           
            Timer.Process();
            if (this.UI.toDelete != null && this.UI.toDelete.len() > 0 ) {
                this.UI.toDelete= this.UI.toDelete.filter(function(idx,e) {
                    e = null;
                    return false;
                }); 
            }
    }     
}   