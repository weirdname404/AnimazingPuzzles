import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    color: "black"

    property int widthK: 27
    property int heightK: 30
    property int cellRows: 4
    property int cellColumns: 5

    property int animationDuration: 5000

    RadialGradient {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "white" }
            GradientStop { position: 0.5; color: "black" }
        }

        property double horizontalK: 0;
        horizontalOffset: horizontalK * root.width / 2

        SequentialAnimation on horizontalK {
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                duration: root.animationDuration
                from: 1
                to: -1
            }
            NumberAnimation {
                duration: root.animationDuration
                from: -1
                to: 1
            }
        }
    }
}
