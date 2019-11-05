using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.Math;

class ForLapRunView extends WatchUi.DataField {
    hidden var timeMark; hidden var distMark;   hidden var AvHRMark;
    hidden var lapTime;  hidden var lapTimeSec; hidden var lapDist;    hidden var lapPace;  hidden var lapPaceMin; hidden var lapHR; hidden var Split;
    
    function initialize() {
        DataField.initialize();
              timeMark = 0.0f;      distMark = 0.0f;       AvHRMark = 0.0f;
              lapTime = 0.0f;       lapTimeSec = 0.0f;     lapDist = 0.0f;        lapPace = 0.0f;     lapPaceMin = 0.0f;      lapHR = 0.0f;     Split = 0.0f;
    }
    function onLayout(dc) {
            View.setLayout(Rez.Layouts.MainLayout(dc));
            var labelView = View.findDrawableById("label");                  labelView.locY =                   labelView.locY-40;                   labelView.locX = labelView.locX-80;
            var labeldevView = View.findDrawableById("labeldev");            labeldevView.locY =             labeldevView.locY-0;              labeldevView.locX = labeldevView.locX-66;
            var labeldev2View = View.findDrawableById("labeldev2");        labeldev2View.locY =             labeldev2View.locY-57;           labeldev2View.locX = labeldev2View.locX-17;

            var OnLtlapPaceMinView = View.findDrawableById("lablapPaceMin");  OnLtlapPaceMinView.locY =  OnLtlapPaceMinView.locY-57;  OnLtlapPaceMinView.locX = OnLtlapPaceMinView.locX-42;
            var OnLtlapPaceView = View.findDrawableById("lablapPace");        OnLtlapPaceView.locY =        OnLtlapPaceView.locY-57;        OnLtlapPaceView.locX = OnLtlapPaceView.locX+29;
            var OnLtlapTimeView = View.findDrawableById("lablapTime");        OnLtlapTimeView.locY =         OnLtlapTimeView.locY+0;        OnLtlapTimeView.locX = OnLtlapTimeView.locX-88;
            var OnLtlapTimeSecView = View.findDrawableById("lablapTimeSec");  OnLtlapTimeSecView.locY =   OnLtlapTimeSecView.locY+0;  OnLtlapTimeSecView.locX = OnLtlapTimeSecView.locX-44;
            var OnLtSplitView = View.findDrawableById("labSplit");                     OnLtSplitView.locY = OnLtSplitView.locY-00;           OnLtSplitView.locX = OnLtSplitView.locX+10;
            var OnLtlapDistView = View.findDrawableById("lablapDist");        OnLtlapDistView.locY =         OnLtlapDistView.locY+0;        OnLtlapDistView.locX = OnLtlapDistView.locX+74;
            var OnLtlapHRView = View.findDrawableById("lablapHR");           OnLtlapHRView.locY =           OnLtlapHRView.locY+51;           OnLtlapHRView.locX = OnLtlapHRView.locX+ 0;

        View.findDrawableById("label").setText(Rez.Strings.label);
        View.findDrawableById("labeldev").setText(Rez.Strings.labeldev);
        View.findDrawableById("labeldev2").setText(Rez.Strings.labeldev);
        return true;
    }
    function compute(info) {
    }
    function onUpdate(dc) {
        var info = Activity.getActivityInfo();
        if(info.timerTime/1000 - timeMark < 20) {if(info.currentSpeed < 1) {lapPaceMin = 0.0f; lapPace = 0.0f;}
                                                 else                      {lapPaceMin = 1000/info.currentSpeed/60; if(lapPaceMin<Math.round(lapPaceMin)) {lapPace = 1000/info.currentSpeed-Math.round(1000/info.currentSpeed/60)*60+60;}
                                                                                                                    else                                  {lapPace = 1000/info.currentSpeed-Math.round(1000/info.currentSpeed/60)*60;}}}

        else                                    {if(info.timerTime/1000>timeMark && info.elapsedDistance/1000>distMark) {lapPaceMin = (info.timerTime/1000-timeMark)/(info.elapsedDistance/1000-distMark)/60;if(lapPaceMin<Math.round(lapPaceMin)){lapPace = (info.timerTime/1000-timeMark)/(info.elapsedDistance/1000-distMark)-Math.round(lapPaceMin)*60+60;}
                                                                                                                                                                                                             else                                 {lapPace = (info.timerTime/1000-timeMark)/(info.elapsedDistance/1000-distMark)-Math.round(lapPaceMin)*60;}}
                                                 else                                                                   {lapPaceMin = 0.0f; lapPace = 0.0f;}}
        if(info.currentHeartRate == null) {lapHR = 0.0f;}
        else                              {if(lapPaceMin > 2/6 && info.timerTime/1000 > timeMark) {lapHR = (info.averageHeartRate*info.timerTime/1000-AvHRMark*timeMark)/(info.timerTime/1000-timeMark);}
                                           else                                                   {lapHR = info.currentHeartRate;}}
        if(lapHR > 0 && lapDist > 0.8) {Split = lapHR - (277.51-0.41*lapPaceMin*60);}
        else                           {Split = 0.0f;}
        if(info.timerTime == null)  {lapTime = 0.0f;} 
        else                        {lapTime = (info.timerTime/1000-timeMark)/60;}
        if(info.timerTime == null)  {lapTimeSec = 0.0f;}
                                    {if(lapTime<Math.round(lapTime)) {lapTimeSec = info.timerTime/1000-timeMark-Math.round(lapTime)*60+60;}
                                     else                            {lapTimeSec = info.timerTime/1000-timeMark-Math.round(lapTime)*60;} }
        if(info.elapsedDistance == null)  {lapDist = 0.0f;}
        else                              {lapDist = info.elapsedDistance/1000-distMark;}
        //View
        View.findDrawableById("Background").setColor(Graphics.COLOR_BLACK);
        var OnLtlapPaceMin = View.findDrawableById("lablapPaceMin"); OnLtlapPaceMin.setColor(Graphics.COLOR_WHITE);  OnLtlapPaceMin.setText(lapPaceMin.format("%01d"));
        var OnLtlapPace = View.findDrawableById("lablapPace");       OnLtlapPace.setColor(Graphics.COLOR_WHITE);     OnLtlapPace.setText(lapPace.format("%02d"));
        var OnLtlapTime = View.findDrawableById("lablapTime");       OnLtlapTime.setColor(Graphics.COLOR_LT_GRAY);   OnLtlapTime.setText(lapTime.format("%02d"));
        var OnLtlapTimeSec = View.findDrawableById("lablapTimeSec"); OnLtlapTimeSec.setColor(Graphics.COLOR_LT_GRAY);OnLtlapTimeSec.setText(lapTimeSec.format("%02d"));
        var OnLtSplit = View.findDrawableById("labSplit");           OnLtSplit.setColor(Graphics.COLOR_LT_GRAY);     OnLtSplit.setText(Split.format("%.0f"));
        var OnLtlapDist = View.findDrawableById("lablapDist");       OnLtlapDist.setColor(Graphics.COLOR_LT_GRAY);   {if(lapDist<10) {OnLtlapDist.setText(lapDist.format("%.2f"));}else{OnLtlapDist.setText(lapDist.format("%.1f"));}}
        var OnLtlapHR = View.findDrawableById("lablapHR");           OnLtlapHR.setColor(Graphics.COLOR_WHITE);       OnLtlapHR.setText(lapHR.format("%.0f"));
        View.onUpdate(dc);
    }
    function onTimerLap() {
        var info = Activity.getActivityInfo();
        if(info.timerTime != null)       {timeMark = info.timerTime/1000; distMark = info.elapsedDistance/1000; AvHRMark = info.averageHeartRate;}
        else                             {timeMark = 0.0f; distMark = 0.0f; AvHRMark = 0.0f;}
    }
    function onTimerReset() { timeMark = 0.0f; distMark = 0.0f; AvHRMark = 0.0f;
    }
}