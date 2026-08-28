import Toybox.Lang;
import Toybox.WatchUi;

class stairchallengeMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        var app = getApp();
        if (item == :item_lap) {
            app.addLap();
        } else if (item == :item_save) {
            app.finishAndSave();
        } else if (item == :item_discard) {
            app.discardActivity();
        }
        WatchUi.requestUpdate();
    }

}
