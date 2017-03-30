/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

import TyphoonHQuickInterface               1.0

//-------------------------------------------------------------------------
//-- RC Wignal/Battery Indicator
Item {
    width:          rcRow.width
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    function getBatteryColor() {
        if(TyphoonHQuickInterface.rcBattery > 0.75) {
            return qgcPal.colorGreen
        }
        if(TyphoonHQuickInterface.rcBattery > 0.5) {
            return qgcPal.colorOrange
        }
        if(TyphoonHQuickInterface.rcBattery > 0.1) {
            return qgcPal.colorRed
        }
        return qgcPal.text
    }

    function getBatteryPercentageText() {
        if(TyphoonHQuickInterface.rcBattery > 0.98) {
            return "100%"
        }
        if(TyphoonHQuickInterface.rcBattery > 0.1) {
            return (TyphoonHQuickInterface.rcBattery * 100).toFixed(0) + '%'
        }
        return "N/A"
    }

    function getBatteryIcon() {
        if(TyphoonHQuickInterface.rcBattery > 0.95) {
            return qgcPal.globalTheme === QGCPalette.Light ? "/typhoonh/battery_100Dark.svg" : "/typhoonh/battery_100.svg"
        } else if(TyphoonHQuickInterface.rcBattery > 0.75) {
            return qgcPal.globalTheme === QGCPalette.Light ? "/typhoonh/battery_80Dark.svg" : "/typhoonh/battery_80.svg"
        } else if(TyphoonHQuickInterface.rcBattery > 0.55) {
            return qgcPal.globalTheme === QGCPalette.Light ? "/typhoonh/battery_60Dark.svg" : "/typhoonh/battery_60.svg"
        } else if(TyphoonHQuickInterface.rcBattery > 0.35) {
            return qgcPal.globalTheme === QGCPalette.Light ? "/typhoonh/battery_40Dark.svg" : "/typhoonh/battery_40.svg"
        } else if(TyphoonHQuickInterface.rcBattery > 0.15) {
            return qgcPal.globalTheme === QGCPalette.Light ? "/typhoonh/battery_20Dark.svg" : "/typhoonh/battery_20.svg"
        }
        return qgcPal.globalTheme === QGCPalette.Light ? "/typhoonh/battery_0Dark.svg" : "/typhoonh/battery_0.svg"
    }

    Component {
        id: rcInfo

        Rectangle {
            width:  rcCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: rcCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 rcCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(rcrssiGrid.width, rssiLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             rssiLabel
                    text:           qsTr("RC Status")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 rcrssiGrid
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    anchors.horizontalCenter: parent.horizontalCenter

                    QGCLabel { text: qsTr("RC RSSI:") }
                    QGCLabel { text: _activeVehicle ? (_activeVehicle.rcRSSI > 100 ? 'N/A' : _activeVehicle.rcRSSI + "%") : 'N/A' }
                    QGCLabel { text: qsTr("RC Battery:") }
                    QGCLabel { text: getBatteryPercentageText() }
                    QGCLabel { text: qsTr("RC GPS Sat Count:") }
                    QGCLabel { text: TyphoonHQuickInterface.gpsCount.toFixed(0) }
                    QGCLabel { text: qsTr("RC GPS Accuracy:") }
                    QGCLabel { text: TyphoonHQuickInterface.gpsAccuracy.toFixed(1) }
                    QGCLabel { text: qsTr("RC Ground Speed:") }
                    QGCLabel { text: TyphoonHQuickInterface.speed.toFixed(1) }
                }
            }

            Component.onCompleted: {
                var pos = mapFromItem(toolBar, centerX - (width / 2), toolBar.height)
                x = pos.x
                y = pos.y + ScreenTools.defaultFontPixelHeight
            }
        }
    }

    Row {
        id:             rcRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth
        QGCColoredImage {
            anchors.top:        parent.top
            width:              height
            anchors.bottom:     parent.bottom
            sourceSize.height:  height
            source:             "/qmlimages/RC.svg"
            fillMode:           Image.PreserveAspectFit
            opacity:            _activeVehicle ? 1 : 0.5
            color:              qgcPal.buttonText
        }
        Column {
            anchors.verticalCenter: parent.verticalCenter
            SignalStrength {
                size:                   rcRow.height * 0.4
                percent:                _activeVehicle ? ((_activeVehicle.rcRSSI > 100) ? 0 : _activeVehicle.rcRSSI) : 0
                opacity:                _activeVehicle ? 1 : 0.5
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Row {
                height:                 rcRow.height * 0.6
                spacing:                ScreenTools.defaultFontPixelWidth
                Image {
                    anchors.top:        parent.top
                    anchors.bottom:     parent.bottom
                    width:              height
                    sourceSize.width:   width
                    source:             getBatteryIcon()
                    fillMode:           Image.PreserveAspectFit
                }
                QGCLabel {
                    text:                   getBatteryPercentageText()
                    color:                  qgcPal.buttonText
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            var centerX = mapToItem(toolBar, x, y).x + (width / 2)
            mainWindow.showPopUp(rcInfo, centerX)
        }
    }
}