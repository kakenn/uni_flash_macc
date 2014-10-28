package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	
	public class main extends MovieClip {
		
		public var fields = new Array();
		public var dongris = new Array();
		
		public var shikao = new Shikao();	//鹿

		public function main() {
			// フィールド生成
			createField();
			
			// フィールド生成
			addDonguri(5);
			
			//しかお追加
			addChild(shikao);
			
			//移動をスタック
			shikao.addMoveStack(100,100);
			shikao.addMoveStack(200,100);
			shikao.addMoveStack(200,200);
			
			//移動開始
			shikao.move();
			
			addEventListener(MouseEvent.CLICK,function(){
				shikao.moveStop();
			})
		}
		
		public function createField(){
			for(var i=0;i<8;i++){
				fields[i] = new Array();
				dongris[i] = new Array();
				for(var j=0;j<6;j++){
					
					//フィールド生成
					fields[i][j]=new Field();
					fields[i][j].x=i*112;
					fields[i][j].y=j*90;
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
					dongris[_x][_y].x=_x*112; 
					dongris[_x][_y].y=_y*90;
					addChild(dongris[_x][_y]);
				}else{
					
					//その場所にあった場合再度場所指定
					i--;
				}
			}
		}
		
		
	}
	
}
