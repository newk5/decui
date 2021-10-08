UI.SpriteSheet({
    id="spriteSheet"
    FrameSize = VectorScreen(64, 64)
    align = "center"
    onStart = function() {
        Console.Print("started");
    }
    onEnd = function() {
        Console.Print("finished");
    }
    sprite = {
        id="sprite"
        file="spritesheet.png" // using this image --> https://i.ibb.co/8dVGb3v/spritesheet.png
        Size = VectorScreen(128, 128)

    }
})