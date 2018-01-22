import QtQuick 2.0

Rectangle {
    id: root
    color: "black"
    clip: true // Prevent drawing outside of item's area

    property int widthK: 27
    property int heightK: 30
    property int cellRows:4
    property int cellColumns: 4

    property double stickWidth: root.width / 20

    Item {
        anchors.centerIn: parent
        transformOrigin: Item.Center

        NumberAnimation on rotation {
            duration: 100000
            from: 0
            to: 360
            loops: NumberAnimation.Infinite
        }

        Rectangle {
            id: stick
            anchors.centerIn: parent
            width: Math.max(root.height, root.width) * 2
            height: root.stickWidth
            color: "white"
        }
        Rectangle {
            id: stick2
            anchors.centerIn: parent
            width: stick.height
            height: stick.width
            color: "white"
        }
    }
}
