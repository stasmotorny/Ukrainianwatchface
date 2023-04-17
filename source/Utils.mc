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

    function drawCommentedValue(dc,value,value_color,comment,comment_color,x,y, font){
        dc.setColor(value_color,Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            y,
            font,
            value,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(comment_color,Gfx.COLOR_TRANSPARENT);
        dc.drawText(
            x,
            y + 10,
            font,
            comment,
            Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER
        );
    }
	
    function renderHeartrate(heartrate, dc, beatsPerMinute, hours_width, hours_height, comfortaaSmall) {
        if (heartrate != null) {
            drawCommentedValue(
                dc,
                heartrate,
                0x007BFF,
                beatsPerMinute,
                0x979595,
                (dc.getWidth() - hours_width) / 4,
                dc.getHeight() / 2 - hours_height / 2 - 17,
                comfortaaSmall
            );
        } else {
            drawCommentedValue(
                dc,
                "",
                0x007BFF,
                beatsPerMinute,
                0x979595,
                (dc.getWidth() - hours_width) / 4,
                dc.getHeight() / 2 - hours_height / 2 - 17,
                comfortaaSmall
            );
        }
    }
}
