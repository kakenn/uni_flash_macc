package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class main extends MovieClip {
		public const FIELD_START_X = 32; 	//フィールドの開始点_X
		public const FIELD_START_Y = 50; 	//フィールドの開始点_Y
		public var fields = new Array();
		public var dongris = new Array();
		
		public var shikao = new Shikao(FIELD_START_X,FIELD_START_Y,112,90);	//鹿
		
		public var fieldSelectFlag = false;
		public var fieldSelectStack = new Array();

		public function main() {
			// フィールド生成
			createField();
			
			// フィールド生成
			addDonguri(5);
			
			//しかお追加
			addChild(shikao);
			
			//移動をスタック
			shikao.addMoveStack(1,0);
			shikao.addMoveStack(1,1);
			shikao.addMoveStack(1,2);
			shikao.addMoveStack(2,2);
			shikao.addMoveStack(2,3);
			shikao.addMoveStack(3,3);
			shikao.addMoveStack(4,3);
			shikao.addMoveStack(5,3);
			shikao.addMoveStack(6,3);
			shikao.addMoveStack(7,3);
			shikao.addMoveStack(7,4);
			
			//移動開始
			shikao.move();
			
			addEventListener(MouseEvent.CLICK,function(){
				shikao.moveStop();
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
		
		private function mapSelectStart(e){
			fieldSelectFlag = true;
			fieldSelectStack.push(shikao.pos);
		}
		
		private function mapSelectMove(e){
			if(fieldSelectFlag){
				for(var i=0;i<8;i++){
					for(var j=0;j<6;j++){
						if(fields[i][j].hitTestPoint(stage.mouseX,stage.mouseY)){
							fields[i][j].gotoAndStop(2);
						}
					}
				}
			}
		}
		
		private function mapSelectEnd(e){
			fieldSelectFlag = false;
		}
		
		public function createField(){
			for(var i=0;i<8;i++){
				fields[i] = new Array();
				dongris[i] = new Array();
				for(var j=0;j<6;j++){
					
					//フィールド生成
					fields[i][j]=new Field();
					fields[i][j].x=i*112+FIELD_START_X;
					fields[i][j].y=j*90+FIELD_START_Y;
					addChild(fields[i][j]);


					//どんぐり用配列生成
					dongris[i][j]=null;
				}
			}
		}
		
		public function addDonguri(_num){
			for(var i=0;i<_num;i++){
				//適当に場所を指定
				var _x = Math.floor(Math.random()*8);
				var _y = Math.floor(Math.random()*6);
				
				//その場所にドングリがあるか確認
				if(!dongris[_x][_y]){
					
					//なかったらドングリをその場所に生成
					dongris[_x][_y]=new Donguri();
					
					//座標は適当
					dongris[_x][_y].x=_x*112+FIELD_START_X; 
					dongris[_x][_y].y=_y*90+FIELD_START_Y;
					addChild(dongris[_x][_y]);
				}else{
					
					//その場所にあった場合再度場所指定
					i--;
				}
			}
		}
		
		
	}
	
}
