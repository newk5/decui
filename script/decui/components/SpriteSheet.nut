// base implementation by DMWarrior (https://forum.vc-mp.org/?topic=7586.0) slightly modified and improved (no longer necessary to pass image size or x and y units)
class SpriteSheet extends DecUIComponent {

    spriteObj    = null;
    rows      = null;
    columns   = null;
    imageSize = null; //VectorScreen
    frameSize = null; //VectorScreen
    sheet     = null; //array
    interval  = null;
    timer     = null;
    frame     = null;
    rows      = null;
    columns   = null;
    onStart   = null;
    onEnd     = null;
    paused    = null;
    border    = null;

    constructor(o) {
        base.constructor(o);
    
        this.spriteObj = o.rawin("sprite") ? o.sprite : {};
        this.imageSize = spriteObj.rawin("Size") ? spriteObj.Size : VectorScreen(0,0);
        this.frameSize = o.rawin("FrameSize") ? o.FrameSize :  VectorScreen(32,32);
        this.interval = o.rawin("interval") ? o.interval : 80;
        this.rows = o.rawin("rows") ? o.rows : null;
        this.columns = o.rawin("columns") ? o.columns : null;
        this.onStart = o.rawin("onStart") ? o.onStart : null;
        this.onEnd = o.rawin("onEnd") ? o.onEnd : null;
        this.border = o.rawin("border") ? o.border : null;
        
        this.sheet = [];
        this.frame = 0;
        this.paused = false;

       
        this.build();

    }

    function pause() {
        this.paused = true;
    }

    function play() {
        this.paused = false;;
    }


    function build(){
        local sprite = UI.Sprite(this.spriteObj);
        if (rows == null){
            this.rows    = sprite.TextureSize.Y / this.frameSize.Y;
        }
        if (columns == null){
            this.columns = sprite.TextureSize.X / this.frameSize.X;
        }

   
        local x = this.frameSize.X.tofloat() / sprite.TextureSize.X.tofloat();
        local y = this.frameSize.Y.tofloat() / sprite.TextureSize.Y.tofloat();
        

        local pos = 0;
        for(local row = 0; row < this.rows; row++) {
            for(local column = 0; column < this.columns; column++) {
              this.sheet.push({
                // Frame index.
                index = pos,
        
                // Initial cut position (unit value).
                topLeft = {
                  x = x * column,
                  y = y * row
                },
        
                // Final cut position (unit value).
                bottomRight = {
                  x = (x * column) + x,
                  y = (y * row) + y
                }
              });
        
              pos++;
            }
        }
      
        UI.Canvas({
            id = this.id
            presets = this.presets
            border = this.border
            move = this.move
            align = this.align
            Size = this.imageSize
            children = [
                sprite
            ]
                
        })
        //set the first frame
        this.setFrame(sprite, this.sheet[0]);
        //start looping 
        local frame = 0;
        this.timer= Timer.Create(this, function(sprite) {
            if (!this.paused){
                if (this.onStart != null && this.frame == 0){
                    this.onStart();
                }
                this.setFrame(sprite, this.sheet[this.frame])
                this.frame++; 
            
                if (this.frame >= this.sheet.len()){
                    if (this.onEnd != null){
                        this.onEnd();
                    }
                    this.frame=0;
                }
            }
           
        }, this.interval, 0,sprite);


    }

    function setFrame(sprite, frame) {
        sprite.TopLeftUV.X = frame.topLeft.x;
        sprite.TopLeftUV.Y = frame.topLeft.y;
      
        sprite.BottomRightUV.X = frame.bottomRight.x;
        sprite.BottomRightUV.Y = frame.bottomRight.y;
    }

    function destroy() {
        base.destroy();
        ::Timer.Destroy(this.timer);
    }


}

UI.registerComponent("SpriteSheet", {
    create = function(o) {
        local c = SpriteSheet(o);
        return c;

    }
});