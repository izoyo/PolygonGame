check_flag_end = false;// 游戏结束

function gameCheaker() {
    if(isTrain)
        return;

    if (check_flag_end) {
        document.getElementById("playBoard").style.display = "none";
        document.getElementById("tipEnd").style.display = "block";
        document.getElementById("tipScore").innerText = getScore();
        document.getElementById("useTime").innerText = getFinishTime();
        return;
    }

    var d = new Date();
    if (d.getTime() / 1000 > starTime + timeLimit) {
        console.log("游戏超时");

        check_flag_end = true;
        return;
    }
    // console.log("check");


    if (isEnd()) {
        check_flag_end = true;
        console.log("游戏结束，", getScore(), getBestScore());
        // 上传分数
        var xmlhttp;
        if (window.XMLHttpRequest) {
            xmlhttp = new XMLHttpRequest();//  IE7+, Firefox, Chrome, Opera, Safari 浏览器执行代码
        } else {
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");// IE6, IE5 浏览器执行代码
        }

        xmlhttp.open("POST", "../Game", true);
        xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        xmlhttp.send("ac=up&matchid=" + matchId + "&user=" + user + "&socre=" + getScore() + "&usetime=" + getFinishTime());
        console.log("上传分数");

        return;
    }

}