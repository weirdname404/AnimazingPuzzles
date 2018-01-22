import QtQuick 2.7

Item {
    id: root;

    property bool isSelected: false

    property int tx;
    property int ty;
    property var shaderSource;
    property int sceneRows;
    property int sceneColumns;
    property var clickProcessor;
    property var targetCell;

    property int moveAnimationDuration: 300
    property bool isFixed: true
    property bool isCorrect: tx == targetCell.tx && ty == targetCell.ty

    x: targetCell.x
    y: targetCell.y
    width: targetCell.width
    height: targetCell.height

    Behavior on x {
        NumberAnimation {
            duration: moveAnimationDuration
            easing.type:  Easing.InOutQuad
        }
    }
    Behavior on y {
        NumberAnimation {
            duration: moveAnimationDuration
            easing.type:  Easing.InOutQuad
        }
    }
    Behavior on width {
        NumberAnimation {
            duration: moveAnimationDuration
            easing.type:  Easing.InOutQuad
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: moveAnimationDuration
            easing.type:  Easing.InOutQuad
        }
    }

    // Selection frame
    // Visible only when cell is not fixed
    Rectangle {
        color: "#00000000"
        border.width: 1
        border.color: root.isSelected ? "green" : "#404040"
        visible: !root.isFixed
        z: 2
        anchors.fill: parent
    }

    ShaderEffect {
        anchors.fill: parent
        property variant src: root.shaderSource
        property vector2d texBegin: Qt.vector2d(root.tx / root.sceneColumns, root.ty / root.sceneRows)
        property vector2d texEnd: texBegin.plus(Qt.vector2d(1.0 / root.sceneColumns, 1.0 / root.sceneRows))

        // Draws 1 tile on the screen at 60 fps
        vertexShader: "qrc:/qml/shaders/cell.vert"
        fragmentShader: "qrc:/qml/shaders/cell.frag"
    }

    // Interactions enabled only if cell isn't fixed
    MouseArea {
        enabled: !root.isFixed
        anchors.fill: parent
        onClicked: root.clickProcessor.onClick(root)
//        drag.target: parent
    }
//    Rectangle {
//        anchors.fill: parent
//        anchors.leftMargin: root.width / 3
//        anchors.rightMargin: root.width / 3
//        anchors.bottomMargin: root.height / 3
//        anchors.topMargin: root.height / 3
//        color: "red"
//        visible: root.isCorrect
//    }

//    DropArea {
//        anchors.fill: parent
//        onDropped: {
//            var tmp = root.targetCell
//            root.targetCell = drop.targetCell
//            drop.targetCell = tmp
//            console.log("teh drop")
//        }
//    }
}
