import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Lang;

class stairchallengeView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
    }

    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var app = getApp();
        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var info = Activity.getActivityInfo();

        var y = height * 0.12;
        var lineHeight = height * 0.13;

        dc.drawText(width / 2, y, Graphics.FONT_MEDIUM, statusText(app.activityState), Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight * 1.2;

        dc.drawText(width / 2, y, Graphics.FONT_NUMBER_MEDIUM, formatElapsed(info), Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight * 1.6;

        y = drawMetrics(dc, width, y, lineHeight, info);

        var calText = "Cal --";
        if (info != null && info.calories != null) {
            calText = "Cal " + info.calories;
        }
        dc.drawText(width / 2, y, Graphics.FONT_SMALL, calText + "   Laps " + app.lapCount, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Devices with a barometer (or a GPS altitude fallback): HR row, then a
    // floors up/down row built from totalAscent/totalDescent.
    (:altimeter)
    function drawMetrics(dc as Dc, width as Number, y as Float, lineHeight as Float, info as Activity.Info?) as Float {
        var hrText = "HR --";
        if (info != null && info.currentHeartRate != null) {
            hrText = "HR " + info.currentHeartRate.format("%d");
        }
        dc.drawText(width / 2, y, Graphics.FONT_MEDIUM, hrText, Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;

        // Only devices with a real altitude source (barometer, or GPS as a
        // fallback) can report ascent/descent; skip the row entirely otherwise.
        if (info != null && info.altitude != null) {
            var up = 0;
            var down = 0;
            if (info.totalAscent != null) {
                up = (info.totalAscent / FLOOR_HEIGHT_METERS).toNumber();
            }
            if (info.totalDescent != null) {
                down = (info.totalDescent / FLOOR_HEIGHT_METERS).toNumber();
            }
            dc.drawText(width / 2, y, Graphics.FONT_SMALL, "Up " + up + "  Down " + down, Graphics.TEXT_JUSTIFY_CENTER);
            y += lineHeight;
        }
        return y;
    }

    // fr55 has no barometric altimeter: no floors up/down row at all. HR
    // moves down into the row that would otherwise hold it, leaving its
    // usual row blank instead of showing stale/fake altitude data.
    (:noAltimeter)
    function drawMetrics(dc as Dc, width as Number, y as Float, lineHeight as Float, info as Activity.Info?) as Float {
        y += lineHeight;
        var hrText = "HR --";
        if (info != null && info.currentHeartRate != null) {
            hrText = "HR " + info.currentHeartRate.format("%d");
        }
        dc.drawText(width / 2, y, Graphics.FONT_MEDIUM, hrText, Graphics.TEXT_JUSTIFY_CENTER);
        y += lineHeight;
        return y;
    }

    function statusText(state as Symbol) as String {
        if (state == :recording) {
            return "Recording";
        } else if (state == :paused) {
            return "Paused";
        }
        return "Ready – Select to start";
    }

    function formatElapsed(info as Activity.Info?) as String {
        var ms = 0;
        if (info != null && info.timerTime != null) {
            ms = info.timerTime;
        }
        var totalSec = ms / 1000;
        var hh = totalSec / 3600;
        var mm = (totalSec % 3600) / 60;
        var ss = totalSec % 60;
        return hh.format("%01d") + ":" + mm.format("%02d") + ":" + ss.format("%02d");
    }

    function onHide() as Void {
    }

}
