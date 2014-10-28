package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	public class Shikao extends MovieClip {
		
		private var targetX,targetY;
		private var moveX = 1;			//X移動量基準
		private var moveY = 1;			//Y移動量基準
		private var moveX_Amount;		//１フレーム毎のX移動量
		private var moveY_Amount;		//１フレーム毎のY移動量
		
		public var move_stack = new Array(); //移動のスタック
		public var shika_direction;	//しかおの向き( 0:下 , 1:左 , 2:上 , 3:右 )
		public var moveFinish = new Event("moveFinish");
		public var stackFinish = new Event("stackFinish");
		
		
		public function Shikao() {
			addEventListener("moveFinish",function(){
				move();
			});
		}
		public function addMoveStack(_x,_y){
			move_stack.push([_x,_y]);
		}
		public function moveStop(){
			move_stack = new Array();
		}
		public function move(){
			if(move_stack[0]){
				trace(move_stack[0]);
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
				addEventListener(Event.ENTER_FRAME,mover);
				move_stack.shift();
			}else{
				this.dispatchEvent(stackFinish);
			}
		}
		
		public function mover(e){
			if(Math.abs(moveX_Amount) > Math.abs(this.x-targetX) || Math.abs(moveY_Amount) > Math.abs(this.y-targetY)){
				this.x=targetX;
				this.y=targetY;
				removeEventListener(Event.ENTER_FRAME,mover);
				this.dispatchEvent(moveFinish);
			}else{
				this.x += moveX_Amount;
				this.y += moveY_Amount;
			}
		}
		
	}
	
}
