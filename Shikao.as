package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class Shikao extends MovieClip {

		private var offsetX;			//フィールドの開始点_X
		private var offsetY; 			//フィールドの開始点_Y
		private var fieldW;				//フィールドひとますの幅
		private var fieldH;				//フィールドひとますの高さ
		private var targetX,targetY;	//移動先の座標
		private var moveX = 4;			//X移動量基準
		private var moveY = 4;			//Y移動量基準
		private var moveX_Amount;		//１フレーム毎のX移動量
		private var moveY_Amount;		//１フレーム毎のY移動量
		
		public var pos = new Array()						//しかおのポジション
		public var newPos = new Array()						//しかおのポジション
		public var move_stack = new Array(); 				//移動のスタック
		public var shika_direction;							//しかおの向き( 0:下 , 1:左 , 2:上 , 3:右 )
		public var moveFinish = new Event("moveFinish");	//移動終了イベント
		public var stackFinish = new Event("stackFinish");	//移動のスタック全終了イベント
		
		
		public function Shikao(_offsetX,_offsetY,_fieldW,_fieldH) {
			
			//初期設定
			offsetX = _offsetX-10;
			offsetY = _offsetY+10;
			fieldW = _fieldW;
			fieldH = _fieldH;
			
			//初期位置の設定
			pos = [0,0];
			this.x=offsetX;
			this.y=offsetY;
			
			//移動用のイベントをバインド
			addEventListener("moveFinish",function(){
				move();
			});
		}
		
		public function setInfo(){
		}
		
		//スタック追加
		public function addMoveStack(_x,_y){
			pos = [_x,_y];
			move_stack.push([_x*fieldW+offsetX,_y*fieldH+offsetY]);
		}
		
		//
		public function moveStop(){
			move_stack = new Array();
		}
		
		
		public function move(){
			if(move_stack[0]){
				moveX_Amount = (Number(this.x - move_stack[0][0] < 0)-Number(this.x - move_stack[0][0] >0)) * moveX;
				moveY_Amount = (Number(this.y - move_stack[0][1] < 0)-Number(this.y - move_stack[0][1] >0)) * moveY;
				targetX = move_stack[0][0];
				targetY = move_stack[0][1];
				if(moveX_Amount<0){
					this.gotoAndPlay(22);
					shika_direction=1;
				}else if(moveX_Amount>0){
					this.gotoAndPlay(66);
					shika_direction=3;
				}else if(moveY_Amount<0){
					this.gotoAndPlay(44);
					shika_direction=2;
				}else{
					this.gotoAndPlay(1);
					shika_direction=0;
				}
				this.x += moveX_Amount;
				this.y += moveY_Amount;
				addEventListener(Event.ENTER_FRAME,mover);
				newPos=move_stack[0];
				move_stack.shift();
			}else{
				this.dispatchEvent(stackFinish);
				this.stop();
			}
		}
		
		public function mover(e){
			if(Math.abs(moveX_Amount) > Math.abs(this.x-targetX) || Math.abs(moveY_Amount) > Math.abs(this.y-targetY)){
				this.x=targetX;
				this.y=targetY;
				removeEventListener(Event.ENTER_FRAME,mover);
				this.gotoAndPlay(1);
				pos=newPos;
				this.dispatchEvent(moveFinish);
			}else{
				this.x += moveX_Amount;
				this.y += moveY_Amount;
			}
		}
		
	}
	
}
