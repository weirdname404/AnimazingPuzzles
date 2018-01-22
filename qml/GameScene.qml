import QtQuick 2.7
import QtQuick.Window 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item {
    id: root
    anchors.fill: parent

    // Setup initial(correct) cell positions
    Component.onCompleted: {
        tracker.sendScreenView("Game Level")
        tracker.sendEvent("game_event", "load_level", root.parent.levelSource)

        console.log(cellHolder.children.length);
        var tx = 0;
        var ty = 0;
        for (var i = 0; i < cellHolder.children.length; ++i) {
            var cell = cellHolder.children[i];
            if (cell.sceneColumns) { // Check if element is not Repeater
                var logicalCell = logicalGrid.children[i];
                console.log(tx + " " + ty);
                cell.tx = tx;
                cell.ty = ty;
                logicalCell.tx = tx;
                logicalCell.ty = ty;
                cell.targetCell = logicalCell;

                tx += 1;
                if (tx >= logicalGrid.columns) {
                    tx = 0;
                    ty += 1;
                }
            }
        }

        shuffleTimer.start(); // Start shuffle after some time
    }

    function swapCells(c1, c2) {
        var t = c1.targetCell
        c1.targetCell = c2.targetCell
        c2.targetCell = t;
    }

    Timer {
        id: shuffleTimer
        interval: 2000

        onTriggered: {
            console.log("TRIGGERED");

            // Perform shuffle
            var w = logicalGrid.columns;
            var h = logicalGrid.rows;
            var count = w * h;
            for (var i = 0; i < count; ++i) {
                cellHolder.children[i].isFixed = false;
                var j = Math.floor(count * Math.random())
                swapCells(cellHolder.children[i], cellHolder.children[j]);
            }
        }
    }

    Rectangle {

        id: returnIcon
        anchors.left: parent.left
        anchors.leftMargin: parent.width/70
        anchors.bottom: sceneHolder.top
        anchors.bottomMargin: parent.height/64

        color: "black"

        height: parent.height/20
        width: parent.height/20

        Image {
            anchors.fill: parent
            source: "qrc:/qml/icons/returnIcon.png"
        }

        MouseArea {
            id: returnTap
            anchors.fill: parent
            enabled: true
            onClicked: {
                root.parent.source = "qrc:/qml/LevelSelect.qml"
                tracker.sendEvent("game_event", "game_exit", "User quit the level")
            }
        }
    }

    Item {
        id: counterLabel

        anchors.right: parent.right
        anchors.rightMargin: parent.width/60
        anchors.bottom: sceneHolder.top
        anchors.bottomMargin: parent.height/70
        height: parent.height/20
        width: parent.height/20
        z: 1

        FontLoader {
            id: counterFont
            source: "qrc:/qml/fonts/start.ttf"
        }


        Text  {
            id: counterText

            text: "0"
            anchors.centerIn: parent
            font.pointSize: 30
            color: "white"
            font.family: counterFont.name
        }
    }


    Timer {
        id: blurTimer
        interval: 1500

        onTriggered: {
            blur.visible = true;
            blurAnimation.start();
            textAnimation.start();
            winText.visible = true;
            returnTimer.start();
        }
    }

    Timer {
        id: returnTimer
        interval: 4000

        onTriggered: {root.parent.source = "qrc:/qml/LevelSelect.qml"}
    }

    Item {
        id: winText

        anchors.centerIn: parent
        anchors.horizontalCenter: parent.horizontalCenter
        visible: false
        z: 1

        FontLoader {
            id: startFont
            source: "qrc:/qml/fonts/start.ttf"
        }

        Text  {
            id: text
            anchors.centerIn: parent
            text: "Level complete\n"
            font.pointSize: 22
            color: "white"// "#b82386"
            font.family: startFont.name
//            z: 1

            NumberAnimation on opacity {
                id: textAnimation
                from: 0
                to: 1
                duration: 1000
            }
        }

    }

    Item {
        id: myClickProcessor
        property Item selectedRect;
        property bool isFirstSelected: false;
        property int counter: 0;


        function onClick(root) {
            if (isFirstSelected) {
                tracker.sendEvent("game_event", "cell_swap", "User swapped cells")

                swapCells(root, selectedRect);
                selectedRect.isSelected = false;
                checkWinCondition();
                counter++;
                counterText.text = counter;
            } else {
                root.isSelected = true;
                selectedRect = root;
            }
            isFirstSelected = !isFirstSelected;
        }
        function checkWinCondition() {
            for (var i = 0; i < cellHolder.children.length; ++i) {
                var cell = cellHolder.children[i];
                if (cell.sceneColumns) {
                    if (!cell.isCorrect) {
                        return;
                    }
                }
            }

            tracker.sendEvent("game_event", "game_win", "User won the game");
            tracker.sendEvent("game_event", "level_complete", root.parent.levelSource + " : " + counter.toString())

            // Fix all cells
            var count = logicalGrid.columns * logicalGrid.rows;
            for (var i = 0; i < count; ++i) {
                cellHolder.children[i].isFixed = true;
            }
            blurTimer.start();
        }
    }

    Item {
        id: gridHolder
        anchors.fill: sceneHolder

        GridLayout {
            id: logicalGrid
            rows: levelLoader.item.cellRows
            columns: levelLoader.item.cellColumns
            anchors.fill: parent
            columnSpacing: 0
            rowSpacing: 0

            Repeater {
                model: parent.rows * parent.columns
                Item {
                    property int tx: -1
                    property int ty: -1
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }
        }

        Item {
            id: cellHolder
            anchors.fill: parent
            Repeater {
                model: logicalGrid.rows * logicalGrid.columns
                Cell {
                    shaderSource: shaderSrc
                    sceneColumns: logicalGrid.columns
                    sceneRows: logicalGrid.rows
                    clickProcessor: myClickProcessor
                }
            }
        }
    }

    Item {
        id: sceneHolder
        anchors.centerIn: parent

        width: Math.min(parent.width, levelLoader.item.widthK * parent.height / levelLoader.item.heightK)
        height: Math.min(parent.height, levelLoader.item.heightK * parent.width / levelLoader.item.widthK)

        Loader {
            id: levelLoader
            anchors.fill: parent
            source: root.parent ? root.parent.levelSource : source
        }

        // Draws Item into Texture which can be used by Shader
        ShaderEffectSource {
            id: shaderSrc
            sourceItem: levelLoader.item
            anchors.fill: parent
            visible: false
            hideSource: true
        }

        FastBlur {
            id: blur
            anchors.fill: parent
            source: levelLoader.item
            radius: 100
            visible: false

            NumberAnimation on radius {
                id: blurAnimation
                from: 0
                to: 64
                duration: 200
            }
        }
    }
}
