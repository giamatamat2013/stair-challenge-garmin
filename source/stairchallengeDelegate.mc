import Toybox.Lang;
import Toybox.WatchUi;

class stairchallengeDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Select button: start -> pause -> resume
    function onSelect() as Boolean {
        getApp().toggleRecording();
        WatchUi.requestUpdate();
        return true;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new stairchallengeMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // Block accidental exit while an activity is recording or paused;
    // the user must explicitly Save or Discard from the menu.
    function onBack() as Boolean {
        if (getApp().activityState != :idle) {
            return true;
        }
        return false;
    }

}
