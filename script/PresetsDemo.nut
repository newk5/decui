//add your presets all at once
UI.Presets({
    bigText = {
        FontSize= 30
    }
    mediumText = {
        FontSize= 20
    }

});
//or add them individually
UI.Preset("errorColor",{
    TextColour= ::Colour(255,0,0)
})    

UI.Label({
    id = "newLabelID"  
    Text = "labelText" 
    align ="center"
    presets = ["bigText", "errorColor"]
})
UI.Label({
    id = "newLabelID2"  
    Text = "labelText" 
    presets = ["errorColor", "mediumText"]
    align = "center"
    move ={ up = "10%"}
})