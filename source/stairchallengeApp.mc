import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.ActivityRecording;
import Toybox.Activity;
import Toybox.Timer;

// A standard flight of stairs is ~3m (10ft); used to convert ascent/descent
// meters into whole floors, matching Garmin's own "floors climbed" metric.
const FLOOR_HEIGHT_METERS as Float = 3.0;

class stairchallengeApp extends Application.AppBase {

    var session as ActivityRecording.Session?;
    var activityState as Symbol = :idle; // :idle, :recording, :paused
    var lapCount as Number = 0;
    var updateTimer as Timer.Timer?;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
    }

    function onStop(state as Dictionary?) as Void {
        stopUpdateTimer();
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new stairchallengeView(), new stairchallengeDelegate() ];
    }

    function toggleRecording() as Void {
        if (activityState == :idle) {
            startRecording();
        } else if (activityState == :recording) {
            pauseRecording();
        } else if (activityState == :paused) {
            resumeRecording();
        }
    }

    function startRecording() as Void {
        session = ActivityRecording.createSession({
            :name => "Stair Challenge",
            :sport => Activity.SPORT_FITNESS_EQUIPMENT,
            :subSport => Activity.SUB_SPORT_STAIR_CLIMBING
        });
        session.start();
        activityState = :recording;
        lapCount = 0;
        startUpdateTimer();
    }

    function pauseRecording() as Void {
        if (session != null) {
            session.stop();
        }
        activityState = :paused;
    }

    function resumeRecording() as Void {
        if (session != null) {
            session.start();
        }
        activityState = :recording;
    }

    function addLap() as Void {
        if (session != null && activityState == :recording) {
            session.addLap();
            lapCount++;
        }
    }

    function finishAndSave() as Void {
        if (session != null) {
            if (session.isRecording()) {
                session.stop();
            }
            session.save();
            session = null;
        }
        resetState();
    }

    function discardActivity() as Void {
        if (session != null) {
            if (session.isRecording()) {
                session.stop();
            }
            session.discard();
            session = null;
        }
        resetState();
    }

    function resetState() as Void {
        activityState = :idle;
        lapCount = 0;
        stopUpdateTimer();
        WatchUi.requestUpdate();
    }

    function startUpdateTimer() as Void {
        if (updateTimer == null) {
            updateTimer = new Timer.Timer();
            updateTimer.start(method(:onUpdateTick), 1000, true);
        }
    }

    function stopUpdateTimer() as Void {
        if (updateTimer != null) {
            updateTimer.stop();
            updateTimer = null;
        }
    }

    function onUpdateTick() as Void {
        WatchUi.requestUpdate();
    }

}

function getApp() as stairchallengeApp {
    return Application.getApp() as stairchallengeApp;
}
