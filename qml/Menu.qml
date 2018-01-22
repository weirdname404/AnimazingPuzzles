import QtQuick 2.7

Item {
    id: root
    // parent.height = 960
    // parent.width = 540

    Loader {
        id: menuGif
        source: "qrc:/qml/levels/MenuGif.qml"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.bottomMargin: parent.height*1.3/4.17 //400
    }

    Item {
        id: gameName
        anchors.top: menuGif.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.topMargin: parent.height*1.3/55 // 30
//        anchors.rightMargin: parent.height*1.3/12.8
        anchors.leftMargin: parent.height*1.3/55 // 30


        FontLoader {
            id: arcadeFont
            source: "qrc:/qml/fonts/Games.ttf"
        }

        Text {
            text: "animazing puzzles"
            color: "white"
            font.pointSize:  35 //root.height*1.3/47.5 // 35
            font.family: arcadeFont.name
        }
    }

    Item {
        id: button
        anchors.bottom: parent.bottom
        anchors.right: parent.right
//        anchors.left: parent.left
        anchors.rightMargin: parent.height*1.3/55 // 30

        anchors.bottomMargin: parent.height*1.3/33.28 // 50
        width: text.width + text.height
        height: text.height * 2

        FontLoader {
            id: startFont
            source: "qrc:/qml/fonts/start.ttf"
        }

        Text  {
            id: text

            text: "START"
            font.pointSize: 25//root.height*1.3/66.56 // 25
            color: "white"
            font.family: startFont.name
//            anchors.centerIn: parent
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.parent.source = "qrc:/qml/LevelSelect.qml"
            }
        }
    }

    Component.onCompleted: {
        tracker.sendScreenView("Menu")
    }
}
