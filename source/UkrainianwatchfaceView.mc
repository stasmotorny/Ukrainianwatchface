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
    var fullDayNames as Array<Lang.String> or Null;
    var shortDayNames as Array<String> or Null;
    var metresPerSecond;
    var beatsPerMinute;
    var floors;
    var steps;
    var metres;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        comfortaaLarge=WatchUi.loadResource(Rez.Fonts.ComfortaaLarge);
        comfortaaSmall=WatchUi.loadResource(Rez.Fonts.ComfortaaSmall);
        comfortaaMedium=WatchUi.loadResource(Rez.Fonts.ComfortaaMedium);
        flashIcon = Ui.loadResource(Rez.Drawables.Flash);
        kcalIcon = Ui.loadResource(Rez.Drawables.Kcal);
        metresPerSecond = Ui.loadResource(Rez.Strings.metresPerSecond);
        beatsPerMinute = Ui.loadResource(Rez.Strings.beatsPerMin);
        floors = Ui.loadResource(Rez.Strings.floors);
        steps = Ui.loadResource(Rez.Strings.steps);
        metres = Ui.loadResource(Rez.Strings.metres);

        fullDayNames = [
            Ui.loadResource(Rez.Strings.day0Name),
            Ui.loadResource(Rez.Strings.day1Name),
            Ui.loadResource(Rez.Strings.day2Name),
            Ui.loadResource(Rez.Strings.day3Name),
            Ui.loadResource(Rez.Strings.day4Name),
            Ui.loadResource(Rez.Strings.day5Name),
            Ui.loadResource(Rez.Strings.day6Name)
        ];
        shortDayNames = [
            Ui.loadResource(Rez.Strings.day0Abbr),
            Ui.loadResource(Rez.Strings.day1Abbr),
            Ui.loadResource(Rez.Strings.day2Abbr),
            Ui.loadResource(Rez.Strings.day3Abbr),
            Ui.loadResource(Rez.Strings.day4Abbr),
            Ui.loadResource(Rez.Strings.day5Abbr),
            Ui.loadResource(Rez.Strings.day6Abbr)
        ];

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
        var hours_width = dc.getTextWidthInPixels("22",comfortaaLarge);
        var hours_height = dc.getFontHeight(comfortaaLarge) - 20;

        //Weather block
        var currentWeather = Weather.getCurrentConditions();
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        if (currentWeather != null) {
            dc.drawText(
                dc.getWidth() / 2,
                (dc.getHeight() - hours_height - hours_height - 12) / 4 + 10,
                comfortaaMedium,
                Lang.format("$1$°C | $2$$4$ | $3$%", [currentWeather.temperature, currentWeather.windSpeed.toNumber(), currentWeather.precipitationChance, metresPerSecond]),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        } else {
            dc.drawText(
                dc.getWidth() / 2,
                (dc.getHeight() - hours_height - hours_height - 12) / 4 + 10,
                comfortaaMedium,
                Lang.format("$1$°C | $2$$4$ | $3$%", [0, 0, 0, metresPerSecond]),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        }
       

        // Date block
        var dateShort = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateLong = Gregorian.info(Time.now(), Time.FORMAT_LONG);
        var dateString = Lang.format(
            "$1$ $2$ $3$",
            [
                fullDayNames[dateShort.day_of_week - 1],
                dateShort.day,
                dateLong.month
            ]
        );
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            dc.getWidth() / 2,
            (dc.getHeight() - hours_height * 2 - 12) / 4 - 10,
            comfortaaMedium,
            dateString,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
        );

        //Time block
        var clockTime = System.getClockTime();
        dc.setColor(0x007BFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 - 30, comfortaaLarge, Lang.format("$1$", [clockTime.hour.format("%02d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.setColor(0xFFFF00,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2 + 30, comfortaaLarge, Lang.format("$1$", [clockTime.min.format("%02d")]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        //Heart data
        var currentHeartrate = Activity.getActivityInfo().currentHeartRate;
        Utils.renderHeartrate(currentHeartrate, dc, beatsPerMinute, hours_width, hours_height, comfortaaSmall);

        //Steps data block
        var stepCount = Mon.getInfo().steps;
        Utils.drawCommentedValue(
            dc,
            stepCount,
            0xFFFF00,
            steps,
            0x979595,
            (dc.getWidth() - hours_width) / 4,
            dc.getHeight() / 2 + hours_height / 2 + 8,
            comfortaaSmall
        );

        //Altitude data block
        var currentAltitude = Activity.getActivityInfo().altitude;
        if (currentAltitude != null) {
            currentAltitude = currentAltitude.toNumber();
        }
        Utils.drawCommentedValue(
            dc,
            currentAltitude,
            0xFFFF00,
            metres,
            0x979595,
            (dc.getWidth() - hours_width) / 4 * 3 + hours_width,
            dc.getHeight() / 2 + hours_height / 2 + 8,
            comfortaaSmall
        );

        //Floors data block
        var floorsClimbed = Mon.getInfo().floorsClimbed;
        Utils.drawCommentedValue(
            dc,
            floorsClimbed,
            0x007BFF,
            floors,
            0x979595,
            (dc.getWidth() - hours_width) / 4 * 3 + hours_width,
            dc.getHeight() / 2 - hours_height / 2 - 17,
            comfortaaSmall
        );

        //Bottom block
        var battery = System.getSystemStats().battery.toNumber().toString() + "%";
        var calories = Mon.getInfo().calories;
        var text_width = dc.getTextWidthInPixels(""+calories,comfortaaMedium);
        var y = (dc.getHeight() - hours_height - hours_height - 12) / 4 * 3 + hours_height + hours_height + 12;
        dc.drawBitmap(dc.getWidth() / 2 + 10,y,flashIcon);
        dc.setColor(0xFFFFFF,Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth() / 2 + 30, y, comfortaaMedium, battery, Graphics.TEXT_JUSTIFY_LEFT);

        dc.drawBitmap(dc.getWidth() / 2 - text_width - 30,y,kcalIcon);
        dc.setColor(0xFFFFFF,Graphics.COLOR_TRANSPARENT);
        if (calories != null) {
            dc.drawText(dc.getWidth() / 2 - 10, y, comfortaaMedium, calories.toString(), Graphics.TEXT_JUSTIFY_RIGHT);
        } else {
            dc.drawText(dc.getWidth() / 2 - 10, y, comfortaaMedium, "0", Graphics.TEXT_JUSTIFY_RIGHT);
        }
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
