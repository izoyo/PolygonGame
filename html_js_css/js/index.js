var isGameStart = false;
/**
* 开始游戏
* N: 顶点数
* v: 顶点数组
* op: 边操作符数组 "*" "+"
* isShow: 是否展示最好的做法
* canBack: 能否悔步
* 注：顶点数组与边操作符数组都是从1开始编号，0为空
*/
function start(N, v, op, isShow, canBack) {
	// 测试数据可删除
	var isShow = true;
	// 测试数据可删除
	var canBack = true;
	// 测试数据可删除
	var testN = 6;
	// 测试数据可删除
	var testOp = ["","+","*","+","+","*","*"];
	// 测试数据可删除
	var testV = [0,-444,123,-9943,7052,-2045,5737];
	N = testN;
	v = testV;
	op = testOp;

	// 隐藏showBest画布
	document.getElementById("showBest").style.display = "none";
	if(isShow) {
		// 可显示最佳操作
		document.getElementById("showBestButton").setAttribute("enabled", true);//设置可点击
	} else {
		// 不可显示最佳操作
		document.getElementById("showBestButton").setAttribute("disabled", true);//设置不可点击
	}
	if(canBack) {
		// 可悔步
		document.getElementById("goBackButton").setAttribute("enabled", true);//设置可点击
	} else {
		// 不可悔步
		document.getElementById("goBackButton").setAttribute("disabled", true);//设置可点击
	}
	// 进入算法初始化
	init(N, v, op);
	isGameStart = true;
}

/**
* 游戏是否已经结束
*    1. 已结束 return true
*    2. 未结束 return false
*    注：游戏未开始也会返回false.
*/
function isEnd() {
	if(!isGameStart) {
		console.log("is isGameEnd : "+false);
		return false;
	} else {
		console.log("is isGameEnd : "+isGameEnd());
		return isGameEnd();
	}
}

/**
* 获取最终分数
*    注：游戏结束返回总分，否则返回0.
*/
function getScore() {
	if(isEnd()) {
		console.log("Score : "+getCurrentScore());
		return getCurrentScore();
	} else {
		console.log("Score : "+0);
		return 0;
	}
}

/**
* 获取最佳操作的分数
* 	注：游戏未开始会返回0.
*/
function getBestScore() {
	if(!isGameStart) {
		console.log("bestScore : " + 0);
		return 0;
	} else {
		console.log("bestScore : " + bestScore);
		return bestScore;
	}
}

/**
* 获取完成游戏的耗时（返回时间单位"秒"s）
* 	注：游戏未完成会返回-1.
*/
function getFinishTime() {
	if(!isEnd()) {
		console.log("time : " + -1);
		return 0;
	} else {
		console.log("time : " + getConsumeTime());
		return getConsumeTime();
	}
}
