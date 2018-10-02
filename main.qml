import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 2.1
import QtQuick.Particles 2.0
import QtQml 2.2

Window {
    visible: true
    width: 800
    height: 480
    title: qsTr("Pong 0.1")

    property var speed: {"speed_x": 0,
                         "speed_y": 0}

    property var bar1Event: {"move_up": false,
                             "move_down": false};

    property var bar2Event: {"move_up": false,
                             "move_down": false};

    property var squareballEvent: {"move": false}

    Rectangle{
        focus: true
        id: rect1
        anchors.fill: parent
        color: "black"

        Text{
            id: points_left
            y: parent.Center - 50
            x: parent.width/2 - 150
            color: "white"
            font.pointSize: 50
            text: Number(0)
        }

        Text{
            id: points_right
            y: parent.Center - 50
            x: parent.width/2 + 150
            color: "white"
            font.pointSize: 50
            text: Number(0)
        }

        Keys.onPressed: {
            if (event.key === Qt.Key_Space){
                squareballEvent["move"] = true;

                // y-speed between [-3, 3]
                speed["speed_y"] = Math.random()*(3 + 3) - 3;
                speed["speed_x"] = 6*(0.5-Math.random());
                if(speed["speed_x"] < 0) {speed["speed_x"] += 1}
                else{speed["speed_x"] -= 1}

            }
            if (event.key === Qt.Key_Down) { bar2Event["move_down"] = true; }
            if (event.key === Qt.Key_Up)   { bar2Event["move_up"]   = true; }
            if (event.key === Qt.Key_S)    { bar1Event["move_down"] = true; }
            if (event.key === Qt.Key_W)    { bar1Event["move_up"]   = true; }
        }

        Keys.onReleased: {
            if (event.key === Qt.Key_Down) { bar2Event["move_down"] = false; }
            if (event.key === Qt.Key_Up)   { bar2Event["move_up"]   = false; }
            if (event.key === Qt.Key_S)    { bar1Event["move_down"] = false; }
            if (event.key === Qt.Key_W)    { bar1Event["move_up"]   = false; }
        }

        Timer{

            interval: 50
            running: true
            repeat: true
            onTriggered: {
                var move_ball = function(ball){

                    // bounce from left bar
                    if(bar1.x < ball.x && ball.x < bar1.x+20
                            && ball.y <= bar1.y+80 && ball.y + 15 >=  bar1.y)
                    {
                        speed["speed_x"] = speed["speed_x"]*-1.1;
                        speed["speed_y"] = 3*(0.5-Math.random());
                    }

                    // bounce from right bar
                    if(bar2.x > ball.x && ball.x > bar2.x-20
                            && ball.y <= bar2.y+80 && ball.y + 15 >=  bar2.y)
                    {
                        speed["speed_x"] = speed["speed_x"]*-1.1;
                        speed["speed_y"] = 3*(0.5-Math.random());
                    }

                    // reset from left
                    if(ball.x < 0)
                    {
                        squareballEvent["move"] = false;
                        sqball.x = rect1.width/2;
                        sqball.y = rect1.height/2;
                        points_right.text = parseInt(points_right.text) + 1;
                    }

                    // reset from right
                    if(ball.x > parent.width-15)
                    {
                        squareballEvent["move"] = false;
                        sqball.x = rect1.width/2;
                        sqball.y = rect1.height/2;
                        points_left.text = parseInt(points_left.text) + 1;
                    }

                    // bounce from top
                    if(ball.y < 0) {speed["speed_y"] = speed["speed_y"]*-1;}

                    // bounce from bottom
                    if(ball.y > parent.height-15){
                        speed["speed_y"]= speed["speed_y"]*-1;}
                        ball.y = ball.y + speed["speed_y"]*6
                        ball.x = ball.x + speed["speed_x"]*6
                }

                var move_up = function (bar) {
                    if(bar.y > 0) {bar.y = bar.y - 12}
                    else {}
                }
                var move_down = function(bar) {
                   if(bar.y < parent.height-80) {bar.y = bar.y + 12}
                   else {}
                }

                var ball = sqball;
                if(squareballEvent["move"]) {move_ball(ball)}

                var bar = bar1;
                if (bar1Event["move_up"]) {move_up(bar)}
                if (bar1Event["move_down"]) {move_down(bar)}

                bar = bar2;
                if (bar2Event["move_up"]) {move_up(bar)}
                if (bar2Event["move_down"]) {move_down(bar)}

            }
        }

        Centerbar{
            x: rect1.width/2
        }


        // left bar
        Bar{
           id: bar1
           x: 20
           y: 200
        }

        // right bar
        Bar{
           id: bar2
           x: parent.width - 30
           y: 200
           focus: true

        }

        Squareball{
           id: sqball
           x: rect1.width/2 - 6
           y: rect1.height/2
        }

    }
}
