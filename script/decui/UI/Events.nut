    class Events {


            UI = null;

            constructor(ui) {
                this.UI = ui;

            } 
    
        function onGameResize(){
            
            foreach(i,list in this.UI.lists ) {  
               foreach(c,e in list ) { 
                   if (e.rawin("parents") && e.parents.len() == 0){
                 
                        local doesNotIgnoreEvent =(e.rawin("ignoreGameResizeAutoAdjust") && (e.ignoreGameResizeAutoAdjust  == null || !e.ignoreGameResizeAutoAdjust )) ||  !e.rawin("ignoreGameResizeAutoAdjust");
                        if (e.rawin("RelativeSize") && e.RelativeSize != null && e.RelativeSize.len() > 0){

                            if ( doesNotIgnoreEvent ){
                           
                                ::UI.applyRelativeSize(e); 
                                e.resetPosition();
                                e.realign();
                                if (e.rawin("shiftPos") && e.shiftPos != null){
                                    e.shiftPos(); 
                                } 
                                e.updateBorders();
                            }
                           
                        }else{
                            if ( doesNotIgnoreEvent ){
                                e.resetPosition();
                                e.realign();  
                                if (e.rawin("shiftPos") && e.shiftPos != null){
                                    e.shiftPos(); 
                                }
                            }    
                        }

                        foreach (idx, child in e.getChildren() ){
                            if (doesNotIgnoreEvent){
                                child.resetPosition();
                                child.realign();  
                                if (child.rawin("shiftPos") && child.shiftPos != null){
                                    child.shiftPos(); 
                                }
                            
                           
                              
                                if (child.hidden){
                                    child.hide();
                                }
                                if (child.hidden){
                                    child.hidden = false; //after being realigned, the GUIElement is no longer hidden so we need to re-apply the hidden 'state'
                                    child.hide(); 
                                }
                            }
                            if (child.rawin("onGameResize") && child.onGameResize != null){
                                child.onGameResize();
                            }
                        }
                        if (e.rawin("onGameResize") && e.onGameResize != null){
                            e.onGameResize();
                        }

                        if (e.hidden && doesNotIgnoreEvent){
                            e.hidden = false; //after being realigned, the GUIElement is no longer hidden so we need to re-apply the hidden 'state'
                            e.hide(); 
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
            if (el.rawin("metadata") && el.metadata != null && el.metadata.rawin("list")){

           
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