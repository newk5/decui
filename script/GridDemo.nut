 local grid = UI.Grid({
    id = "grid"
    align = "top_center"
    move = { down = "3%"}
    rows =2
    columns =4
    margin = 5
    cellWidth = 80
    cellHeight = 80
    borderStyle = {
        color =::Colour(255,0,0)
        size = 2
    }
    onHoverOverCell = function(cell){
        cell.Colour = ::Colour(150,200,150);
    }
    onHoverOutCell = function(cell){
       cell.Colour = ::Colour(0,0,0,0);
    }
    onCellClick = function(cell){
        cell.Colour = ::Colour(150,150,200);
    }

});

//adds components to the grid row by row
grid.add(
    UI.Canvas({
        id = "c"
        Color = ::Colour(230,231,92,100)
    })
)
grid.add(
    UI.Canvas({
        id = "c2"
        Color = ::Colour(230,231,92,100)
    })
)

//adds components to the grid  in a specific cell
grid.put(
     UI.Canvas({
        id = "c3"
        Color = ::Colour(10,231,92,100)
    }),
    1, //row
    3 //column
)