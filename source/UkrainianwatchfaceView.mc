import Toybox.Graphics;
import Toybox.Application;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Weather;
using Toybox.ActivityMonitor as Mon;
using Toybox.Time.Gregorian;
using Toybox.WatchUi as Ui;
import Toybox.SensorHistory;

class dataLabel
{
    public var label;
    public var data;
    public function initialize(labelArg, dataArg) {
      label = labelArg;
      data = dataArg;
    }
}

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
    var breath;
    var saturation;
    var energyExpenditure;
    var recovery;
    var activity;
    var weatherArray as Array<Lang.String> or Null;
    var weatherFirstField;
    var weatherSecondField;
    var weatherThirdField;
    var dataFields as Array<dataLabel> or Null;
    var topLeft;
    var bottomLeft;
    var topRight;
    var bottomRight;

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
        breath = Ui.loadResource(Rez.Strings.breath);
        saturation = Ui.loadResource(Rez.Strings.saturation);
        energyExpenditure = Ui.loadResource(Rez.Strings.energyExpenditure);
        recovery = Ui.loadResource(Rez.Strings.recovery);
        activity = Ui.loadResource(Rez.Strings.activity);

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

        System.println(Mon.getInfo().activeMinutesDay.total);

        dataFields = [
            new dataLabel(steps, Mon.getInfo().steps),
            new dataLabel(beatsPerMinute, Activity.getActivityInfo().currentHeartRate),
            new dataLabel(floors, Mon.getInfo().floorsClimbed),
            new dataLabel(metres, Activity.getActivityInfo().altitude),
            new dataLabel(breath, Mon.getInfo().respirationRate),
            // new dataLabel("bb", SensorHistory.getBodyBatteryHistory()),
            new dataLabel(saturation, Activity.getActivityInfo().currentOxygenSaturation),
            // new dataLabel("Stress", SensorHistory.getStressHistory()),
            new dataLabel(energyExpenditure, Activity.getActivityInfo().energyExpenditure),
            new dataLabel(recovery, Mon.getInfo().timeToRecovery),
            new dataLabel(metres, Mon.getInfo().distance * 100),
            new dataLabel(activity, Mon.getInfo().activeMinutesDay.total),
        ];

    //Weather block
        var currentWeather = Weather.getCurrentConditions();
        weatherArray = [
            Lang.format("$1$°C", [currentWeather.temperature]),
            Lang.format("$1$$2$", [currentWeather.windSpeed.toNumber(), metresPerSecond]),
            Lang.format("$1$%", [currentWeather.precipitationChance]),
            Lang.format("$1$%", [currentWeather.relativeHumidity]),
            Lang.format("$1$°C", [currentWeather.feelsLikeTemperature])
        ];
        var fieldOneIndex = Application.getApp().getProperty("weatherFirst");
        var fieldOTwoIndex = Application.getApp().getProperty("weatherSecond");
        var fieldThreeIndex = Application.getApp().getProperty("weatherThird");
        dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
        if (currentWeather != null) {
            dc.drawText(
                dc.getWidth() / 2,
                (dc.getHeight() - hours_height - hours_height - 12) / 4 + 10,
                comfortaaMedium,
                Lang.format("$1$ | $2$ | $3$", [weatherArray[fieldOneIndex] as String, weatherArray[fieldOTwoIndex] as String, weatherArray[fieldThreeIndex] as String]),
                Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER
            );
        } else {
            dc.drawText(
                dc.getWidth() / 2,
                (dc.getHeight() - hours_height - hours_height - 12) / 4 + 10,
                comfortaaMedium,
                Lang.format("$1$ | $2$ | $3$", [0, 0, 0]),
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

    //Left and right datafields
        var topLeft = Application.getApp().getProperty("topLeft");
        var bottomLeft = Application.getApp().getProperty("bottomLeft");
        var topRight = Application.getApp().getProperty("topRight");
        var bottomRight = Application.getApp().getProperty("bottomRight");

        // Top left datafield
        Utils.drawCommentedValue(
            dc,
            dataFields[topLeft].data,
            0x007BFF,
            dataFields[topLeft].label,
            0x979595,
            (dc.getWidth() - hours_width) / 4,
            dc.getHeight() / 2 - hours_height / 2 - 17,
            comfortaaSmall
        );

        // Bottom left datafield
        Utils.drawCommentedValue(
            dc,
            dataFields[bottomLeft].data,
            0xFFFF00,
            dataFields[bottomLeft].label,
            0x979595,
            (dc.getWidth() - hours_width) / 4,
            dc.getHeight() / 2 + hours_height / 2 + 8,
            comfortaaSmall
        );

        //Bottom right datafield
        Utils.drawCommentedValue(
            dc,
            dataFields[bottomRight].data,
            0xFFFF00,
            dataFields[bottomRight].label,
            0x979595,
            (dc.getWidth() - hours_width) / 4 * 3 + hours_width,
            dc.getHeight() / 2 + hours_height / 2 + 8,
            comfortaaSmall
        );

        //Top right datafield
        Utils.drawCommentedValue(
            dc,
            dataFields[topRight].data,
            0x007BFF,
            dataFields[topRight].label,
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

    // Called if user changed settings
    function onSettingsChanged() {
		Ui.requestUpdate();
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
