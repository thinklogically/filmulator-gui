import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import "gui_components"
import "colors.js" as Colors

Rectangle {
    id: root
    property real uiScale: 1
    color: Colors.darkGrayL
    anchors.fill: parent

    signal tooltipWanted(string text, int x, int y)

    ColumnLayout {
        id: settingsList
        spacing: 0 * uiScale
        x: 3 * uiScale
        y: 3 * uiScale
        width: 300 * uiScale

        ToolSlider {
            id: uiScaleSlider
            title: qsTr("User Interface Scale")
            tooltipText: qsTr("This is a multiplier for the size of all controls in the program.\n\nThis setting takes effect after applying settings and then restarting Filmulator.")
            minimumValue: 0.5
            maximumValue: 4.0
            stepSize: 0.1
            tickmarksEnabled: true
            tickmarkFactor: 5
            minorTicksEnabled: true
            value: settings.getUiScale()
            defaultValue: settings.getUiScale()
            changed: false
            onValueChanged: {
                if (Math.abs(value - defaultValue) < 0.05) {
                    uiScaleSlider.changed = false
                } else {
                    uiScaleSlider.changed = true
                }
            }
            Component.onCompleted: {
                uiScaleSlider.tooltipWanted.connect(root.tooltipWanted)
            }
            uiScale: root.uiScale
        }

        ToolSwitch {
            id: mipmapSwitch
            text: qsTr("Smooth editor image")
            tooltipText: qsTr("This enables mipmaps for the Filmulate tab's image view. It's recommended for noisy images where not mipmapping may cause patterns to appear at different zoom levels.\n\nIt has slight impact on responsiveness for the last few tools, but it doesn't affect performance when zooming and panning. It also softens the image slightly, which may be undesireable.\n\nThis is applied as soon as you save settings.")
            isOn: settings.getMipmapView()
            defaultOn: settings.getMipmapView()
            changed: false
            onIsOnChanged: mipmapSwitch.changed = true
            Component.onCompleted: {
                mipmapSwitch.tooltipWanted.connect(root.tooltipWanted)
            }
            uiScale: root.uiScale
        }

        ToolButton {
            id: saveSettings
            text: qsTr("Save Settings")
            tooltipText: qsTr("Apply settings and save for future use")
            width: settingsList.width
            height: 40 * uiScale
            notDisabled: uiScaleSlider.changed || mipmapSwitch.changed
            onTriggered: {
                settings.uiScale = uiScaleSlider.value
                uiScaleSlider.defaultValue = uiScaleSlider.value
                uiScaleSlider.changed = false
                settings.mipmapView = mipmapSwitch.isOn
                mipmapSwitch.defaultOn = mipmapSwitch.isOn
                mipmapSwitch.changed = false
            }
            uiScale: root.uiScale
        }
    }
}
