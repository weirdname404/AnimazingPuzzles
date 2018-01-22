import QtQuick 2.7
import QtQuick.Controls 2.2

Item {
    id: root
    anchors.fill: parent
    SwipeView {
        id: swipeView

        anchors.fill: parent
        anchors.bottomMargin: 300
        anchors.topMargin: 100
        anchors.leftMargin: 50
        anchors.rightMargin: 50

        Repeater {
            model: [
                "qrc:/qml/levels/MenuGif.qml",
                "qrc:/qml/levels/GifLevelSun.qml",
                "qrc:/qml/levels/GifLevel.qml",
                "qrc:/qml/levels/GifLevel2.qml",
                "qrc:/qml/levels/RadGradient.qml",
                "qrc:/qml/levels/Cross.qml",
                "qrc:/qml/levels/GifLevel0.qml",
                "qrc:/qml/levels/GifLevel3.qml",
                "qrc:/qml/levels/GifLevel4.qml",
                "qrc:/qml/levels/GifLevel5.qml",
                "qrc:/qml/levels/PepeLevel.qml"
            ]
            Loader {
                active: SwipeView.isCurrentItem || SwipeView.isNextItem || SwipeView.isPreviousItem
                asynchronous: true
                source: modelData
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.parent.levelSource = swipeView.currentItem.source;
                        root.parent.source = "qrc:/qml/GameScene.qml"
                    }
                }
            }
        }
    }


    Item {
        id: playButton

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 70

        width: text.width
        height: text.height
        anchors.horizontalCenter: parent.horizontalCenter

        FontLoader {
            id: startFont
            source: "qrc:/qml/fonts/start.ttf"
        }

        Text  {
            id: text

            text: "PLAY"
            font.pointSize: 35
            color: "white"
            font.family: startFont.name
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.parent.levelSource = swipeView.currentItem.source;
                root.parent.source = "qrc:/qml/GameScene.qml"
            }
        }
    }

    Component.onCompleted: {
        tracker.sendScreenView("Level select")
    }
}
