package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class main extends MovieClip {
		public const FIELD_START_X = 32; 	//フィールドの開始点_X
		public const FIELD_START_Y = 50; 	//フィールドの開始点_Y
		public var fields = new Array();
		public var donguris = new Array();
		
		public var shikao = new Shikao(FIELD_START_X,FIELD_START_Y,112,90);	//鹿
		
		public var moveingFlag = false;				//しかおが移動中かどうかのフラグ
		public var fieldSelectFlag = false;			//選択中かどうかのフラグ
		public var fieldSelectStack = new Array();	//選択したフィールドのスタック
		public var donguriStack = new Array();		//選択したフィールドのスタック

		public function main() {
			// フィールド生成
			createField();
			
			// フィールド生成
			addDonguri(5);
			
			//しかお追加
			addChild(shikao);
			
			//移動完了したらフラグを戻す
			shikao.addEventListener("stackFinish",function(){
				moveingFlag = false;
				fields[shikao.pos[0]][shikao.pos[1]].gotoAndStop(1);
			});
			
			//半分進んだ時
			shikao.addEventListener("moveHalf",function(){
				fields[shikao.pos[0]][shikao.pos[1]].gotoAndStop(1);
				
				//移動先にどんぐりがあるか判断
				if(donguris[shikao.newPos[0]][shikao.newPos[1]]){
					
					//あったら消す
					removeChild(donguris[shikao.newPos[0]][shikao.newPos[1]]);
					donguris[shikao.newPos[0]][shikao.newPos[1]]=null;
					
					/*
						スコア追加とかここじゃなないですかね。
					*/
				}
			});
			
			//画面クリックで移動をストップ
			addEventListener(MouseEvent.CLICK,function(){
				if(moveingFlag){
					trace("moveStop");
					shikao.moveStop();
				}
			});
			
			/*
				マップ用
			*/
			
			//選択開始
			addEventListener(MouseEvent.MOUSE_DOWN,mapSelectStart);
			
			//選択移動
			addEventListener(MouseEvent.MOUSE_MOVE,mapSelectMove);
			
			//選択終了
			addEventListener(MouseEvent.MOUSE_UP,mapSelectEnd);
		}
		
		/*==========
			フィールド選択用
		==========*/
		
		private function mapSelectStart(e){
			
			trace(moveingFlag);
			trace(shikao.pos);
			if(!moveingFlag && fields[shikao.pos[0]][shikao.pos[1]].hitTestPoint(stage.mouseX,stage.mouseY)){
				//スタックを初期化
				fieldSelectStack = new Array();
				donguriStack = new Array();
				
				//フィールド選択フラグを立てる
				fieldSelectFlag = true;
				
				//現在のしかおの位置をスタックに追加
				fieldSelectStack.push(shikao.pos);
				
				//現在のしかおの位置を選択状態にする。
				fields[shikao.pos[0]][shikao.pos[1]].gotoAndStop(2);
			}
		}
		
		private function mapSelectMove(e){
			
			//マウスダウン状態かどうか。
			if(fieldSelectFlag){
				for(var i=0;i<8;i++){
					for(var j=0;j<6;j++){
						if(fields[i][j].hitTestPoint(stage.mouseX,stage.mouseY) && fields[i][j].currentFrame == 1){

							//初期設定をfalseに
							var flag = false;
							
							//横軸が同じ場合
							if(fieldSelectStack[0][0]==i){
								
								//縦に±1だった場合にフラグを立てる
								if(fieldSelectStack[0][1]-1==j || fieldSelectStack[0][1]+1==j){
									flag=true;
								}
								
							//縦軸が同じ場合
							}else if(fieldSelectStack[0][1]==j){
								
								//横に±1だった場合にフラグを立てる
								if(fieldSelectStack[0][0]-1==i || fieldSelectStack[0][0]+1==i){
									flag=true;
								}
							}
							if(flag){
								
								//見た目を変更
								fields[i][j].gotoAndStop(2);
								
								//スタックに追加
								fieldSelectStack.unshift([i,j]);
								
								if(donguris[i][j]){
									donguriStack.push([i,j]);
									trace("stack");
								}
							}
							
						}
					}
				}
			}
		}
		
		//移動を開始
		private function mapSelectEnd(e){
			
			if(fieldSelectFlag){
				//フラグを戻す
				fieldSelectFlag = false;
			
				var donguriFlag = false;

				for(var i=0;i<fieldSelectStack.length;i++){
					if( donguriStack.length > 0 && fieldSelectStack[i][0] == donguriStack[donguriStack.length-1][0] && fieldSelectStack[i][1] == donguriStack[donguriStack.length-1][1]){
						donguriFlag=true;
						break;
					}else{
						fields[fieldSelectStack[i][0]][fieldSelectStack[i][1]].gotoAndStop(1);
						fieldSelectStack.shift();
						i--;
					}
				}
				
				//スタックを逆順から引き出し
				for(i=fieldSelectStack.length-2;i>=0;i--){
					
					if(donguriFlag){
						shikao.addMoveStack(fieldSelectStack[i][0],fieldSelectStack[i][1]);
					}
				
				}
				if(donguriFlag){
					//移動開始
					shikao.move();
					moveingFlag = true;
					trace("!!!");
				}else{
					trace(shikao.pos);
					moveingFlag = false;
				}
			}
		}
		

		/*==========
			フィールド生成用
		==========*/
		public function createField(){
			for(var i=0;i<8;i++){
				fields[i] = new Array();
				donguris[i] = new Array();
				for(var j=0;j<6;j++){
					
					//フィールド生成
					fields[i][j]=new Field();
					fields[i][j].x=i*112+FIELD_START_X;
					fields[i][j].y=j*90+FIELD_START_Y;
					addChild(fields[i][j]);


					//どんぐり用配列生成
					donguris[i][j]=null;
				}
			}
		}
		
		public function addDonguri(_num){
			for(var i=0;i<_num;i++){
				//適当に場所を指定
				var _x = Math.floor(Math.random()*8);
				var _y = Math.floor(Math.random()*6);
				
				//その場所にドングリがあるか確認
				if(!donguris[_x][_y]){
					
					//なかったらドングリをその場所に生成
					donguris[_x][_y]=new Donguri();
					
					//座標は適当
					donguris[_x][_y].x=_x*112+FIELD_START_X; 
					donguris[_x][_y].y=_y*90+FIELD_START_Y;
					addChild(donguris[_x][_y]);
				}else{
					
					//その場所にあった場合再度場所指定
					i--;
				}
			}
		}
		
		
	}
	
}
