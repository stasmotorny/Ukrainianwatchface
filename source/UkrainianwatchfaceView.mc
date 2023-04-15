import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Weather;
using Toybox.ActivityMonitor as Mon;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;

class UkrainianwatchfaceView extends WatchUi.WatchFace {
    var width, height;
	var comfortaaLarge = null;
    var comfortaaSmall = null;
    var comfortaaMedium = null;
    var flashIcon;
    var kcalIcon;

    function initialize() {
        WatchFace.initialize();

        flashIcon = Ui.loadResource(Rez.Drawables.Flash);
        kcalIcon = Ui.loadResource(Rez.Drawables.Kcal);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        comfortaaLarge=WatchUi.loadResource(Rez.Fonts.ComfortaaLarge);
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
        var hours_width = dc.getTextWidthInPixels(""+"22",comfortaaLarge);

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
            55,
            comfortaaMedium,
            today.day_of_week.toString() + " " + today.day + " " + today.month,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Time block
        var clockTime = System.getClockTime();
        dc.setColor(0x007BFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 22.5, comfortaaLarge, Lang.format("$1$", [clockTime.hour.format("%02d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(0xFFFF00,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 22.5, comfortaaLarge, Lang.format("$1$", [clockTime.min.format("%02d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        //Heart data
        var heartrateIterator = ActivityMonitor.getHeartRateHistory(null, false);
	    var currentHeartrate = heartrateIterator.next().heartRate.toString();
        Utils.drawCommentedValue(dc,currentHeartrate,0x007BFF,"уд./хв.",0x979595,(dc.getWidth() - hours_width) / 4,dc.getHeight() / 2 - 25,comfortaaSmall);

        //Steps data block
        var stepCount = Mon.getInfo().steps.toString();
        Utils.drawCommentedValue(dc,stepCount,0xFFFF00,"Крок.",0x979595,(dc.getWidth() - hours_width) / 4,dc.getHeight() / 2 + 15,comfortaaSmall);

        //Altitude data block
        var currentAltitude = Activity.getActivityInfo().altitude.toString();
        Utils.drawCommentedValue(dc,currentAltitude,0xFFFF00,"Метр.",0x979595,(dc.getWidth() - hours_width) / 4 * 3 + hours_width,dc.getHeight() / 2 + 15,comfortaaSmall);

        //Floors data block
        var floorsClimbed = Mon.getInfo().floorsClimbed.toString();
        Utils.drawCommentedValue(dc,floorsClimbed,0x007BFF,"Пов.",0x979595,(dc.getWidth() - hours_width) / 4 * 3 + hours_width,dc.getHeight() / 2 - 25,comfortaaSmall);

        //Bottom block
        var battery = System.getSystemStats().battery.toNumber().toString() + "%";
        var calories = Mon.getInfo().calories.toString();
        var text_width = dc.getTextWidthInPixels(""+calories,comfortaaMedium);
        dc.drawBitmap(dc.getWidth() / 2 + 10,200,flashIcon);
        dc.setColor(0xFFFFFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 + 30, 200, comfortaaMedium, battery, Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawBitmap(dc.getWidth() / 2 - text_width - 30,200,kcalIcon);
        dc.setColor(0xFFFFFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 - 10, 200, comfortaaMedium, calories, Graphics.TEXT_JUSTIFY_RIGHT);
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
