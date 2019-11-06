using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

class ForLapRunView extends WatchUi.DataField {
    var timeMark;  var     distMark;       var AvHRMark;
    var lapTimeMin;var     lapTimeSec;     var lapDist;  var    lapPaceMin;    var lapPaceSec;    var lapHR;    var EstimHR;
    var lapPace;
    
    function initialize() {
        DataField.initialize();
        timeMark = 0.0f;   distMark = 0.0f;    AvHRMark = 0.0f;
        lapTimeMin = 0.0f; lapTimeSec = 0.0f;  lapDist = 0.0f;  lapPaceMin = 0.0f; lapPaceSec = 0.0f; lapHR = 0.0f; EstimHR = 0.0f;
        lapPace = 0.0f;
    }
    function onLayout(dc) {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");                  labelView.locY =                   labelView.locY-40;                    labelView.locX = labelView.locX-80;
            var labeldevView = View.findDrawableById("labeldev");            labeldevView.locY =             labeldevView.locY- 0;              labeldevView.locX = labeldevView.locX-66;
            var labeldev2View = View.findDrawableById("labeldev2");          labeldev2View.locY =           labeldev2View.locY-57;            labeldev2View.locX = labeldev2View.locX-17;

            var OnLtlapPaceMinView = View.findDrawableById("lablapPaceMin"); OnLtlapPaceMinView.locY = OnLtlapPaceMinView.locY-57;  OnLtlapPaceMinView.locX = OnLtlapPaceMinView.locX-42;
            var OnLtlapPaceSecView = View.findDrawableById("lablapPaceSec"); OnLtlapPaceSecView.locY = OnLtlapPaceSecView.locY-57;  OnLtlapPaceSecView.locX = OnLtlapPaceSecView.locX+29;
            var OnLtlapTimeMinView = View.findDrawableById("lablapTimeMin"); OnLtlapTimeMinView.locY = OnLtlapTimeMinView.locY+ 0;  OnLtlapTimeMinView.locX = OnLtlapTimeMinView.locX-88;
            var OnLtlapTimeSecView = View.findDrawableById("lablapTimeSec"); OnLtlapTimeSecView.locY = OnLtlapTimeSecView.locY+ 0;  OnLtlapTimeSecView.locX = OnLtlapTimeSecView.locX-44;
            var OnLtEstimHRView = View.findDrawableById("labEstimHR");       OnLtEstimHRView.locY =       OnLtEstimHRView.locY+ 0;            OnLtEstimHRView.locX = OnLtEstimHRView.locX+10;
            var OnLtlapDistView = View.findDrawableById("lablapDist");       OnLtlapDistView.locY =       OnLtlapDistView.locY+ 0;        OnLtlapDistView.locX = OnLtlapDistView.locX+74;
            var OnLtlapHRView = View.findDrawableById("lablapHR");           OnLtlapHRView.locY =           OnLtlapHRView.locY+51;            OnLtlapHRView.locX = OnLtlapHRView.locX+ 0;

        View.findDrawableById("label").setText(Rez.Strings.label);
        View.findDrawableById("labeldev").setText(Rez.Strings.labeldev);
        View.findDrawableById("labeldev2").setText(Rez.Strings.labeldev);
        return true;
    }
    function compute(info) {

        // Calculate: HR
        if(info has :currentHeartRate) {if(info.currentHeartRate == null) {lapHR = 0.0f;}
                                        else                              {if(lapTimeMin > 2/6 && info.timerTime/1000 > timeMark && info.averageHeartRate != null) {lapHR = (info.averageHeartRate*info.timerTime/1000-AvHRMark*timeMark)/(info.timerTime/1000-timeMark);}
                                                                           else                                                                                    {lapHR = info.currentHeartRate;}}}
        // Calculate: Time
        if(info has :timerTime) {if(info.timerTime == null){lapTimeMin = 0.0f; lapTimeSec = 0.0f;}
                                 else                      {lapTimeMin = (info.timerTime/1000-timeMark)/60; lapTimeSec = info.timerTime/1000-timeMark-Math.round(lapTimeMin-0.5)*60;}}
        // Calculate: Dist
        if(info has :elapsedDistance) {if(info.elapsedDistance == null){lapDist = 0.0f;}
                                       else                            {lapDist = info.elapsedDistance/1000-distMark;}}
        // Calculate: Pace
        if(info has :timerTime) {if(info has :elapsedDistance) {if(info.timerTime != null && info.elapsedDistance != null && info.elapsedDistance/1000 > distMark) {lapPace = (info.timerTime/1000-timeMark)/(info.elapsedDistance/1000-distMark); lapPaceMin = lapPace/60; lapPaceSec = lapPace-Math.round(lapPaceMin-0.5)*60;}}}
        // Calculate: EstHR
        if(info has :currentHeartRate) {if(info has :timerTime) {if(info has :elapsedDistance) {if(info.timerTime != null && info.elapsedDistance != null && info.currentHeartRate != null && info.elapsedDistance/1000 > distMark && lapHR>10) {EstimHR = lapHR-(277.51-0.41*lapPace);}
                                                                                                else                                                                                                                                            {EstimHR = 0.0f;}}}}
    }
    function onUpdate(dc) {
        View.findDrawableById("Background").setColor(Graphics.COLOR_BLACK);
        var OnLtlapPaceMin = View.findDrawableById("lablapPaceMin"); OnLtlapPaceMin.setColor(Graphics.COLOR_WHITE);  OnLtlapPaceMin.setText(lapPaceMin.format("%01d"));
        var OnLtlapPaceSec = View.findDrawableById("lablapPaceSec"); OnLtlapPaceSec.setColor(Graphics.COLOR_WHITE);  OnLtlapPaceSec.setText(lapPaceSec.format("%02d"));
        var OnLtlapTimeMin = View.findDrawableById("lablapTimeMin"); OnLtlapTimeMin.setColor(Graphics.COLOR_LT_GRAY);OnLtlapTimeMin.setText(lapTimeMin.format("%02d"));
        var OnLtlapTimeSec = View.findDrawableById("lablapTimeSec"); OnLtlapTimeSec.setColor(Graphics.COLOR_LT_GRAY);OnLtlapTimeSec.setText(lapTimeSec.format("%02d"));
        var OnLtEstimHR = View.findDrawableById("labEstimHR");       OnLtEstimHR.setColor(Graphics.COLOR_LT_GRAY);   OnLtEstimHR.setText(EstimHR.format("%.0f"));
        var OnLtlapDist = View.findDrawableById("lablapDist");       OnLtlapDist.setColor(Graphics.COLOR_LT_GRAY);   {if(lapDist<10) {OnLtlapDist.setText(lapDist.format("%.2f"));}else{OnLtlapDist.setText(lapDist.format("%.1f"));}}
        var OnLtlapHR = View.findDrawableById("lablapHR");           OnLtlapHR.setColor(Graphics.COLOR_WHITE);       OnLtlapHR.setText(lapHR.format("%.0f"));
        View.onUpdate(dc);
    }
    function onTimerLap() {
        var info = Activity.getActivityInfo();
        if(info.timerTime != null) {timeMark = info.timerTime/1000; distMark = info.elapsedDistance/1000; AvHRMark = info.averageHeartRate;}
        else                       {timeMark = 0.0f; distMark = 0.0f; AvHRMark = 0.0f;}
    }
    function onTimerReset() { timeMark = 0.0f; distMark = 0.0f; AvHRMark = 0.0f;
    }
}