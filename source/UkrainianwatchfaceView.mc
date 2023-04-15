import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Weather;
using Toybox.ActivityMonitor as Mon;
using Toybox.Time.Gregorian;

class UkrainianwatchfaceView extends WatchUi.WatchFace {
    var width, height;
	var myFontComfortaaLarge = null;
    var comfortaaSmall = null;
    var comfortaaMedium = null;
    var flashIcon;

    function initialize() {
        WatchFace.initialize();

        flashIcon = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.Flash,
            :locX=>140,
            :locY=>200,
            :width=>100,
            :height=>100
        });
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        myFontComfortaaLarge=WatchUi.loadResource(Rez.Fonts.Comfortaa72BoldSmooth);
        comfortaaSmall=WatchUi.loadResource(Rez.Fonts.ComfortaaSmall);
        comfortaaMedium=WatchUi.loadResource(Rez.Fonts.ComfortaaMedium);
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);
        dc.clear();

        //Weather block
        var currentTemperature = Weather.getCurrentConditions().temperature;
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            35,
            comfortaaMedium,
            Lang.format("$1$°C", [currentTemperature]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Date block
        var today = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateString = Lang.format(
            "$1$ $2$ $3$",
            [
                today.day_of_week,
                today.day,
                today.month,
            ]
        );
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            60,
            comfortaaMedium,
            dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Time block
        var clockTime = System.getClockTime();
        dc.setColor(0x007BFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 22.5, myFontComfortaaLarge, Lang.format("$1$", [clockTime.hour.format("%02d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(0xFFFF00,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 22.5, myFontComfortaaLarge, Lang.format("$1$", [clockTime.min.format("%02d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        //Heart data
        var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
	    var currentHeartrate = heartrateIterator.next().heartRate;
        dc.setColor(0x007BFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 4,
            dc.getHeight() / 2 - 25,
            comfortaaSmall,
            Lang.format("$1$", [currentHeartrate]),
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(0x979595,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 4,
            dc.getHeight() / 2 - 15,
            comfortaaSmall,
            "уд./хв.",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Steps data block
        var stepCount = Mon.getInfo().steps.toString();
        dc.setColor(0xFFFF00,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 4,
            dc.getHeight() / 2 + 15,
            comfortaaSmall,
            stepCount,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(0x979595,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 4,
            dc.getHeight() / 2 + 25,
            comfortaaSmall,
            "Крок.",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Altitude data block
        var currentAltitude = Activity.getActivityInfo().altitude.toString();
        dc.setColor(0xFFFF00,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
             dc.getWidth() / 4 * 3,
            dc.getHeight() / 2 + 15,
            comfortaaSmall,
            currentAltitude,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(0x979595,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
             dc.getWidth() / 4 * 3,
            dc.getHeight() / 2 + 25,
            comfortaaSmall,
            "Метр.",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Floors data block
        var floorsClimbed = Mon.getInfo().floorsClimbed.toString();
        dc.setColor(0x007BFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 4 * 3,
            dc.getHeight() / 2 - 25,
            comfortaaSmall,
            floorsClimbed,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );
        dc.setColor(0x979595,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
             dc.getWidth() / 4 * 3,
            dc.getHeight() / 2 - 15,
            comfortaaSmall,
            "Пов.",
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        flashIcon.draw(dc);
        // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
