using Toybox.Graphics as Gfx;
using Toybox.Lang;

module Utils{
	
	function drawIconText(dc,text,x,y,text_color,icon){
	   	dc.setColor(text_color, Gfx.COLOR_TRANSPARENT);
	   	var text_width = dc.getTextWidthInPixels(""+text,Gfx.FONT_SMALL);
        
		if(icon!=null && icon instanceof Toybox.WatchUi.BitmapResource){
			dc.drawText(x+icon.getWidth()/2-text_width/2+7, y+2, Gfx.FONT_SMALL, text, Gfx.TEXT_JUSTIFY_VCENTER|Gfx.TEXT_JUSTIFY_LEFT);
			dc.drawBitmap(x-icon.getWidth()/2-text_width/2,y-icon.getHeight()/2,icon);
		}else{
			dc.drawText(x-text_width/2+7, y+2, Gfx.FONT_SMALL, text, Gfx.TEXT_JUSTIFY_VCENTER|Gfx.TEXT_JUSTIFY_LEFT);
		}
	}

    function drawCommentedValue(
        dc,
        value as Lang.String or Null or Lang.Float,
        value_color,
        comment as Lang.String,
        comment_color,
        x,
        y,
        font
    ){
        if (value instanceof Lang.Float) {
            value = value.toNumber();
        }
        dc.setColor(value_color,Gfx.COLOR_TRANSPARENT);
        if (value != null) {
            dc.drawText(
                x,
                y,
                font,
                value.toString(),
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
            );
        } else {
            dc.drawText(
                x,
                y,
                font,
                "0",
                Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
            );
        }
        dc.setColor(comment_color,Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            y + 15,
            font,
            comment,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
        );
    }
}
