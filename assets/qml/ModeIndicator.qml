/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                              2.11
import QtQuick.Controls                     2.4

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
//-------------------------------------------------------------------------
//-- Mode Indicator
Row {
    id:             indicatorRow
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    spacing:        ScreenTools.defaultFontPixelWidth
        QGCComboBox {
            anchors.verticalCenter: parent.verticalCenter
            alternateText:          _activeVehicle ? _activeVehicle.flightMode : ""
            model:                  _flightModes
            font.pointSize:         ScreenTools.mediumFontPointSize
            currentIndex:           -1
            sizeToContents:         true

            property bool showIndicator: true

            property var _activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle
            property var _flightModes:      _activeVehicle ? _activeVehicle.flightModes : [ ]

            onActivated: {
                console.log("the index is " + index);
                if(index==8){
                    index = 3;
                    console.log("changed index to " + index);
                }
                else{
                activateCleaning.checked = 0;
                }
                _activeVehicle.flightMode = _flightModes[index];
                console.log("Flight Mode now " + _activeVehicle.flightMode);
                currentIndex = -1
            }
        }
        QGCCheckBox{
            id:activateCleaning
            // x:0
            y:5
            text: qsTr("Vertical Movement")
            property var _activeVehicle:    QGroundControl.multiVehicleManager.activeVehicle
            property var _flightModes:      _activeVehicle ? _activeVehicle.flightModes : [ ]
            property var modeNow: _activeVehicle.flightMode
            property string path: "C:/Users/Admin/Desktop/json_data/verticalMode.json"

            onModeNowChanged: {
                console.log("Mode Changed!!");
                if(_activeVehicle.flightMode !== "Depth Hold" ){
                    checked = 0
                }
                if(_activeVehicle.flightMode === "Depth Hold" ){
                    var statusVertical = _activeVehicle.readJsonFile(path)
                    checked = statusVertical["isVerticalActive"]
                }
            }
            onCheckedChanged:{
                var statusVertical = _activeVehicle.readJsonFile(path)
                if(_activeVehicle.flightMode === "Depth Hold" && checked){
                        console.log("Vertical Mode Activated");
                       _activeVehicle.updateJsonData(1);
                        return;
                }
                if (statusVertical["isVerticalActive"] === checked){
                    return; //do not update the JSON file
                }
                _activeVehicle.updateJsonData(0);
                checked = false
            }
        }
        Timer {
                property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
                property string path: "C:/Users/Admin/Desktop/json_data/verticalMode.json"
                id: timerCleaning
                interval: 1000 // Check every second (adjust as needed)
                repeat: true
                running: true
                onTriggered: {
                    var statusVertical = _activeVehicle.readJsonFile(path)
                    if(statusVertical["isVerticalActive"] === 0){
                        activateCleaning.checked = 0;
                    }
                    else if(statusVertical["isVerticalActive"] === 1){
                        activateCleaning.checked = 1;
                    }
                }
        }
}
