import QtQuick 2.11
import QtQuick.Window 2.11

Window {
    id: root

    function permutate(arr) {
        if (arr.length === 1) {
            return arr
        } else if (arr.length === 2) {
            return [[arr[0], arr[1]], [arr[1], arr[0]]]
        } else {
            var temp = []
            for (var i = 0; i < arr.length; ++i) {
                var save = arr[i]
                arr.splice(i, 1) // 取出 arr[i]
                var result = permutate(arr) // 递归排列 [arr[0], arr[1], ..., arr[i-1], arr[i+1], ..., arr[n]]
                arr.splice(i, 0, save) // 将 arr[i] 放入数组，保持原来的位置
                for (var j = 0; j < result.length; ++j) {
                    result[j].push(arr[i])
                    temp.push(result[j]) // 将 arr[j] 组合起来
                }
            }
            return temp
        }
    }

    function polygonArea(X, Y, numPoints) {
        var area = 0
        var j = numPoints - 1

        for (var i = 0; i < numPoints; i++) {
            area = area + (X[j] + X[i]) * (Y[j] - Y[i])
            j = i
        }
        return area / 2
    }

    function getArea() {
        var area = 0
        var arrX = []
        var arrY = []
        var arr = permutate([2, 3, 4, 5])
        for (var i = 0; i < arr.length; ++i) {
            var list = arr[i]
            var X = [touch1.x]
            var Y = [touch1.y]
            for (var j = 0; j < list.length; ++j) {
                var index = list[j]
                if (index === 2) {
                    X.push(touch2.x)
                    Y.push(touch2.y)
                } else if (index === 3) {
                    X.push(touch3.x)
                    Y.push(touch3.y)
                } else if (index === 4) {
                    X.push(touch4.x)
                    Y.push(touch4.y)
                } else if (index === 5) {
                    X.push(touch5.x)
                    Y.push(touch5.y)
                }
            }

            var result = polygonArea(X, Y, 5)
            if (result > area) {
                area = result
                arrX = X
                arrY = Y
            }
        }

        return area
    }

    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    visibility: Window.Maximized

    Text {
        id: text
        color: "red"
        font.pixelSize: 25
        z: 1
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "lightblue"
    }

    MultiPointTouchArea {
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 5
        touchPoints: [
            TouchPoint {
                id: touch1
            },
            TouchPoint {
                id: touch2
            },
            TouchPoint {
                id: touch3
            },
            TouchPoint {
                id: touch4
            },
            TouchPoint {
                id: touch5

                property double area: 0
                onPressedChanged: {
                    if (pressed) {
                        area = getArea()
                    } else {
                        area = 0
                        rect.scale = 1
                        text.text = ""
                    }
                }
                onXChanged: {
                    var per = getArea() / area
                    rect.scale = per
                    text.text = per
                }
            }
        ]
    }
}
