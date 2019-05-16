var v; // 顶点数组
var op; // 边数组
var m; // m[i][j][0]和m[i][j][1]分别链p(i,j)的最小值和最大值
var MAXN = 1024;
var path = []; // 最佳边删除序列
var backtrack;
var count = 0;
var N = 0; // 顶点数
var maxValue; // 顶点最大值
var minValue; // 顶点最小值
var tempMinf;
var tempMaxf;
var bestScore;

// 初始化算法的数据
function initValue() {
	linelist = [];
	pointlist = [];
	coorlist = [];
	coordinate = [];
	coordinate1 = [];
	coorlist1 = [];
	path = [];
	bestScore = 0;
	m = new Array(N+1);
	for(var i = 0;i<=N;i++){
		m[i] = new Array(N+1);
		for(var j=0 ;j<=N;j++){
			m[i][j] = new Array(2);
		}
	}
	backtrack = new Array(N+1);
	for(var i = 0;i<=N;i++){
		backtrack[i] = new Array(N+1);
	}
	v[0] = 0;
	op[0] = '';
	var distance = 200;
	var centerX = canvas.width/2;
	var centerY = canvas.height/2;
	for(var i=1; i<=N; i++) {
		// 生成顶点横坐标
		var x = centerX + Math.round(distance*Math.sin(Math.PI*2 / N * i-1));
		// 生成顶点纵坐标
		var y = centerY + Math.round(distance*Math.cos(Math.PI*2 / N * i-1));
		// // 随机生成范围的顶点数据
		// v[i] = Math.round(Math.random()*(maxValue-minValue+1)+minValue);
		// 随机生成单个边的操作符
	    // if(Math.random()>0.5)
	    //     op[i] = "*";
	    // else
	    //     op[i] = "+";
	    for(var j = 2;j<=N;j++) {
	    	m[i][j][0] = MAXN;
			m[i][j][1] = MAXN*(-1);
	    }
	    m[i][1][0] = v[i];
	    m[i][1][1] = v[i];
        var c = new coor(x,y,op[i],v[i]);
        coordinate.push(c); 
	}
    coorlist.push(coordinate);
}

function init(N, v, op) {
	this.N = N;
	this.op = op;
	this.v = v;
    initValue();
	polygonGame(N);
    play();
}

function getValue(){
	initValue();

	for(var i = 0;i<N;i++){
		var value = document.getElementById('v'+i).value;

		var operation= document.getElementById('op'+i).value;
		m[i][1][0] = Number(value);
		m[i][1][1] = Number(value);
		for(var j = 2;j<=N;j++){
			m[i][j][0] = MAXN;
			m[i][j][1] = MAXN*(-1);	
		}
		v[i] = Number(value);
		op[i] = operation;
	}

	polygonGame(N);
	play();
}


function polygonGame(n){
	var i,j;
	console.log(n);
	for(j = 2;j<=n;j++){
		for(i=1;i<=n;i++){
			dealFunc(n,i,j)
		}
	}
	console.log(op);
	console.log(v);
	var max = m[1][n][1];
	var p = 1;
	for(i = 1;i<=n; i++){
		console.log("delete:"+i+"all:"+m[i][n][1]);
		if(max < m[i][n][1]){
			max = m[i][n][1];
			p = i;
		}
	}
	console.log("delete:"+p+"all:"+max);
	console.log(m);
	bestScore = max;
	console.log("max : " + bestScore);
	backtrack[0][0] = p;
	dealPath(max,p,n);
	path.push(p)
	path.reverse();
	console.log(path);
}


function dealPath(val,i,j){
	if(j==1)
		return;

	for(var k = 1;k<j;k++){
		var a = m[i][k][0];
		var b = m[i][k][1];
		var next = i+k;
		if(next>N)
			next%=N;
		var c = m[next][j-k][0];
		var d = m[next][j-k][1];
		if(op[next] == "+"){
			var num1 = b + d;
			var num2 = a + c;
			if(val == num1){
				path.push(next)
				dealPath(b,i,k)
				dealPath(d,next,j-k)
				break;
			}
			else if(val == num2){
				path.push(next)
				dealPath(a,i,k)
				dealPath(c,next,j-k)
				break;
			}
		}else{
			var num1 = a * c;
			var num2 = a * d;
			var num3 = b * c;
			var num4 = b * d;
			if(val == num1){
				path.push(next)
				dealPath(a,i,k)
				dealPath(c,next,j-k)
				break;
			}
			else if(val == num2){
				path.push(next)
				dealPath(a,i,k)
				dealPath(d,next,j-k)
				break;
			}
			else if(val == num3){
				path.push(next)
				dealPath(b,i,k)
				dealPath(c,next,j-k)
				break;
			}

			else if(val == num4){
				path.push(next)
				dealPath(b,i,k)
				dealPath(d,next,j-k)
				break;
			}
		}
	}
}

/**
* 
*/
function dealFunc(n,i,j){
	for(var k = 0;k<j;k++){
		var a = m[i][k][0];
		var b = m[i][k][1];
		var next = i+k;
		if(next>N)
			next%=N;
		var c = m[next][j-k][0];
		var d = m[next][j-k][1];
		var maxf,minf;
		if(op[next] == '+'){
			maxf = b+d;
			minf = a+c;
		}else{
			var e = new Array(4);
			e[0] = a*c;
			e[1] = a*d;
			e[2] = b*d;
			e[3] = b*c;
			minf = e[0];
			maxf = e[0];
			for(var t = 1;t<4;t++){
				if(minf>e[t])
					minf = e[t];
				if(maxf<e[t]){
					maxf=e[t];
				}
			}
		}
		if(m[i][j][0]>minf)
			m[i][j][0] = minf;
		if(m[i][j][1]<maxf){
			m[i][j][1]=maxf;
            backtrack[i][j] = k;
		}

	}
}