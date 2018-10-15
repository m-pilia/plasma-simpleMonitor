/**
 * Copyright 2013-2016 Dhaby Xiloj, Konstantin Shtepa
 *
 * This file is part of plasma-simpleMonitor.
 *
 * plasma-simpleMonitor is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or any later version.
 *
 * plasma-simpleMonitor is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied
 * warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with plasma-simpleMonitor.  If not, see <http://www.gnu.org/licenses/>.
 **/

import QtQuick 2.0
import QtQuick.Layouts 1.1

Item {
    property double usage: 0.0
    property double temp: 0.0
    property double memFree: 0.0
    property double memTotal: 0.0
    property double memCached: 0.0
    property double memUsed: 0.0
    property double memBuffers: 0.0
    property alias memTypeLabel : memType.text

    implicitWidth: memColumn.implicitWidth
    implicitHeight: memColumn.implicitHeight

    FontLoader {
        id: doppioOneRegular
        source: "../../fonts/Doppio_One/DoppioOne-Regular.ttf"
    }

    ColumnLayout {
        id: memColumn

        spacing: 2 * units.devicePixelRatio
        anchors.fill: parent

        RowLayout {
            spacing: 3 * units.devicePixelRatio
            Text {
                text: "GPU: "
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "#ffdd55"
            }
            Text {
                text: gpuName
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "white"
            }
        }

        RowLayout {
            spacing: 3 * units.devicePixelRatio
            Text {
                text: i18n("Temp:")
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "#ffdd55"
            }
            Text {
                text: if (tempUnit === 0) Math.floor(temp) + "°C"
                      else Math.floor(temp*9/5+32) + "°F"
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "white"
            }
        }

        RowLayout {
            spacing: 3 * units.devicePixelRatio
            Text {
                id: memType
                text: i18n("Mem:")
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "#ffdd55"
            }
            Text {
                text: i18n("%1 GiB", memTotal.toFixed(2))
                font { family: doppioOneRegular.name; pointSize: 12 }
                color: "white"
            }
        }

        RowLayout {
            id: memoryInfoLabels
            spacing: 3 * units.devicePixelRatio
            property int fontSize : 8
            Text {
                text: i18n("Used:")
                color: "red"
                font.pointSize: memoryInfoLabels.fontSize
            }
            Text {
                id: memUsedText
                text: i18n("%1 GiB", (memUsed-(memBuffers+memCached)).toFixed(2))
                color: "white"
                font.pointSize: memoryInfoLabels.fontSize
            }
            Text {
                text: i18n("Free:")
                color: "#7ec264"
                font.pointSize: memoryInfoLabels.fontSize
            }
            Text {
                id: memFreeText
                text: i18n("%1 GiB", (memFree+(memBuffers+memCached)).toFixed(2))
                color: "white"
                font.pointSize: memoryInfoLabels.fontSize
            }
        }

        Rectangle {
            id: rectTotalMemory
            height: 7 * units.devicePixelRatio
            Layout.fillWidth: true
            color: "#7ec264"
            Rectangle {
                id: rectUsedMemory
                anchors.left: parent.left
                height: parent.height
                width: (memUsed-(memBuffers+memCached))/memTotal*parent.width
                color: "red"
            }
        }

        RowLayout {
            spacing: 5 * units.devicePixelRatio
            anchors.left: parent.left
            Text {
                id: cpuLabel
                text: i18n('Usage:')
                font.bold: true
                font { family: doppioOneRegular.name; pointSize: 10 }
                color: "#ffdd55"
            }
            Text {
                text: Math.floor(usage) + '%'
                font.bold: true
                font.pointSize: 10
                color: "white"
            }
        }

        RowLayout {
            Item {
                id: progressBar
                height: 10 * units.devicePixelRatio
                //clip: true
                Layout.fillWidth: true
                Rectangle {
                    // clear background
                    anchors.fill: parent
                    radius: 2
                    gradient: Gradient {
                        GradientStop {
                            position: 0.00;
                            color: "#99000000";
                        }
                        GradientStop {
                            position: 0.25;
                            color: "#55555555";
                        }
                        GradientStop {
                            position: 1.00;
                            color: "transparent";
                        }
                    }
                    border.color: "#33ffffff"
                }

                Rectangle {
                    id: rectValue
                    // rectangle whit value change and crop
                    anchors.left: parent.left
                    height: parent.height
                    color: "transparent"
                    clip: true
                    border.color: "#33ffffff"
                    width: Math.floor(usage/100*(parent.width-5))
                    Rectangle {
                        id: bgGradient
                        // rectangle of color, in background for less cpu load
                        anchors.left: parent.left
                        height: progressBar.width
                        width: progressBar.height
                        gradient: Gradient {
                            GradientStop {
                                position: 1.00;
                                color: "#4dffffff";
                            }
                            GradientStop {
                                position: 0.00;
                                color: progressColor;
                            }
                        }
                        transform: [
                            Rotation { id: colorRotation; origin.x:0; origin.y:0; angle:0 },
                            Translate { id: colorTraslation; x: 0; y:0 } ]
                        Component.onCompleted: {
                            if (LayoutMirroring.enabled) {
                                colorRotation.angle = 270
                                colorTraslation.y = Qt.binding(function() { return width });
                                colorTraslation.x = Qt.binding(function() { return -height + width });
                            }
                            else {
                                colorRotation.angle = 90
                                colorTraslation.x = Qt.binding(function() { return height });
                            }
                        }

                    }
                    Rectangle {
                        // rectangle of shadow, in background for less cpu load
                        anchors.left: parent.left
                        height: progressBar.height
                        width: progressBar.width
                        gradient: Gradient {
                            GradientStop {
                                position: 0.00;
                                color: "#99000000";
                            }
                            GradientStop {
                                position: 0.25;
                                color: "#55555555";
                            }
                            GradientStop {
                                position: 0.88;
                                color: "transparent";
                            }
                            GradientStop {
                                position: 1.00;
                                color: "#eeffffff";
                            }
                        }
                    }
                }
                Rectangle {
                    height: progressBar.height + 4 * units.devicePixelRatio
                    width: 5 * units.devicePixelRatio
                    radius: 2 * units.devicePixelRatio
                    anchors.left: rectValue.right
                    anchors.verticalCenter: parent.verticalCenter
                    color: "#88ffffff"
                }
            }
        }
    }
}
