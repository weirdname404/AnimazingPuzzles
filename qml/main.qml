import QtQuick 2.7
import QtQuick.Window 2.2
import analytics 0.1

Window {
    id: appWindow
    visible: true
    height: 1280 * 0.75
    width: 720 * 0.75
    title: qsTr("Animazing Puzzles")
    color: "black"

    Tracker {
        id: tracker
        logLevel: Tracker.Debug
        sendInterval: 20*1000
        viewportSize: qsTr("%1x%2").arg(appWindow.width).arg(appWindow.height)
        trackingID: "UA-110935421-1"
    }

    Loader {
        anchors.fill: parent
        source: "qrc:/qml/Menu.qml"

        property var levelSource;
    }

    Component.onDestruction: {
        tracker.endSession()
    }
}
