package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import flash.utils.getTimer;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class TopDownDrive extends MovieClip 
	{
		
		// constants
		static const speed:Number = .3;
		static const turnSpeed:Number = .2;
		static const guySize:Number = 50;
		static const mapRect:Rectangle = new Rectangle(-50,-50,3001,3001); /*(-50,-800,3001,3750);*/
		//static const numPigStage1:uint = 20;
		//static const numTrashObject1:uint = 35;
		//static const pickupDistance:Number = 100;
		//static const maxCarry:uint = 100;
		
		
		// game objects
		private var barrier:Array;
		//private var trashObjects:Array;
		//private var pig:Array;
		
		
	
		// game variables
		private var arrowLeft, arrowRight, arrowUp, arrowDown:Boolean;
		private var onboard:Array;
		private var lastTime:int;
		//private var totalTrashObjects:int;
		
		private var lastObject:Object;
		//private var Score:Number = 0;
		//private var CornCount:Number = 25;
		//private var txtScore:String;
		//private var txtCornCount:String;
		
		 
		
		
		
		
		
		
		

		public function startTopDownDrive() 
		{
			
			findBarrier();
			//placeTrash();
			//placeTrash1();
			
			gamesprite.setChildIndex(gamesprite.guy,gamesprite.numChildren-1);
			
			// add listeners
			this.addEventListener(Event.ENTER_FRAME,gameLoop);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			
			// set up game variables
			onboard = new Array(0,0,0);
			//totalTrashObjects = 0;
			
			centerMap();
			
			
			
		}
		
		// find all Block objects
		public function findBarrier() 
		{
			barrier = new Array();
			for(var i=0;i<gamesprite.numChildren;i++) 
			{
				var mc = gamesprite.getChildAt(i);
				if (mc is Barrier) 
				{
					// add to array and make invisible
					barrier.push(mc);
					mc.visible = false;
				}
			}
		}
		
		// create random Trash objects 
		//public function placeTrash() 
//		{
//			pig = new Array();
//			for(var p:int=0;p<numPigStage1;p++) 
//			{
//				
//				// loop forever
//				while (true) 
//				{
//					
//					// random location
//					var x:Number = Math.floor(Math.random()*mapRect.width)+mapRect.x;
//					var y:Number = Math.floor(Math.random()*mapRect.height)+mapRect.y;
//					
//					// check all blocks to see if it is over any
//					var isOnBlock:Boolean = false;
//					for(var n:int=0;n<blocks.length;n++) 
//					{
//						if (blocks[n].hitTestPoint(x+gamesprite.x,y+gamesprite.y)) 
//						{
//							isOnBlock = true;
//							break;
//						}
//					}
//					
//					// not over any, so use location
//					if (!isOnBlock) 
//					{
//						var newObject:TrashObject = new TrashObject();
//						newObject.x = x;
//						newObject.y = y;
//						newObject.gotoAndStop(Math.floor(Math.random()*3)+1);
//						gamesprite.addChild(newObject);
//						pig.push(newObject);
//						break;
//					}
//				}
//			}
//		}
//		
//		// create random Trash objects 
//		    public function placeTrash1() 
//			{
//			trashObjects = new Array();
//			for(var i:int=0;i<numTrashObject1;i++) 
//			{
//				
//				// loop forever
//				while (true) 
//				{
//					
//					// random location
//					var x:Number = Math.floor(Math.random()*mapRect.width)+mapRect.x;
//					var y:Number = Math.floor(Math.random()*mapRect.height)+mapRect.y;
//					
//					// check all blocks to see if it is over any
//					var isOnBlock:Boolean = false;
//					for(var j:int=0;j<blocks.length;j++) 
//					{
//						if (blocks[j].hitTestPoint(x+gamesprite.x,y+gamesprite.y)) 
//						{
//							isOnBlock = true;
//							break;
//						}
//					}
//					
//					// not over any, so use location
//					if (!isOnBlock) 
//					{
//						var newObject:TrashObject1 = new TrashObject1();
//						newObject.x = x;
//						newObject.y = y;
//						newObject.gotoAndStop(Math.floor(Math.random()*3)+1);
//						gamesprite.addChild(newObject);
//						trashObjects.push(newObject);
//						break;
//					}
//				}
//			}
//		}
//		
		//note key presses, set properties
		public function keyDownFunction(event:KeyboardEvent) 
		{
			if (event.keyCode == 37) 
			{
				arrowLeft = true;
			} else if (event.keyCode == 39) 
			{
				arrowRight = true;
			} else if (event.keyCode == 38) 
			{
				arrowUp = true;
			} else if (event.keyCode == 40) 
			{
				arrowDown = true;
			}
		}
		
		public function keyUpFunction(event:KeyboardEvent) 
		{
			if (event.keyCode == 37) 
			{
				arrowLeft = false;
			} else if (event.keyCode == 39) 
			{
				arrowRight = false;
			} else if (event.keyCode == 38) 
			{
				arrowUp = false;
			} else if (event.keyCode == 40) 
			{
				arrowDown = false;
			}
		}

		// main game code
		public function gameLoop(event:Event) 
		{
			// calculate time passed
			if (lastTime == 0) lastTime = getTimer();
			var timeDiff:int = getTimer()-lastTime;
			lastTime += timeDiff;
			// rotate left or right
			if (arrowLeft) 
			{
				rotateGuy(timeDiff,"left");
			}
			if (arrowRight) 
			{
				rotateGuy(timeDiff,"right");
			}
			
			// move car
			if (arrowUp) 
			{
				moveGuy(timeDiff);
				centerMap();
				checkCollisions();
				checkCollisionsPig();
			}
		}
		
		// make sure car stays at center of screen
		public function centerMap() 
		{
			gamesprite.x = -gamesprite.car.x + 275;
			gamesprite.y = -gamesprite.car.y + 200;
		}
		
		//public function rotateCar(timeDiff:Number, direction:String) 
//		{
//			if (direction == "left") 
//			{
//				gamesprite.car.rotation -= turnSpeed*timeDiff;
//			} else if (direction == "right") 
//			{
//				gamesprite.car.rotation += turnSpeed*timeDiff;
//			}
//		}
		
		// move car forward
		public function moveGuy(timeDiff:Number) 
		{
			// calculate current car area
			var guyRect = new Rectangle(gamesprite.guy.x-guySize/2, gamesprite.guy.y-guySize/2, guySize, guySize);
			
			// calculate new car area
			var newGuyRect = guyRect.clone();
			var guyAngle:Number = (gamesprite.guy.rotation/360)*(2.0*Math.PI);
			var dx:Number = Math.cos(guyAngle);
			var dy:Number = Math.sin(guyAngle);
			newGuyRect.x += dx*speed*timeDiff;
			newGuyRect.y += dy*speed*timeDiff;
			
			// calculate new location
			var newX:Number = gamesprite.guy.x + dx*speed*timeDiff;
			var newY:Number = gamesprite.guy.y + dy*speed*timeDiff;
			
			// loop through blocks and check collisions
			for(var i:int=0;i<barrier.length;i++)
			for(var p:int=0;p<barrier.length;p++)
			{
				
				// get block rectangle, see if there is a collision
				var barrierRect:Rectangle = barrier[i].getRect(gamesprite);
				//var blockRect:Rectangle = blocks[p].getRect(gamesprite);
				if (barrierRect.intersects(newGuyRect)) 
				{
		
					// horizontal push-back
					if (guyRect.right <= barriersRect.left) 
					{
						newX += barriersRect.left - newGuyRect.right;
					} else if (guyRect.left >= barriersRect.right) 
					{
						newX += barriersRect.right - newGuyRect.left;
					}
					
					// vertical push-back
					if (guyRect.top >= barriersRect.bottom) 
					{
						newY += barriersRect.bottom-newGuyRect.top;
					} else if (guyRect.bottom <= barriersRect.top) 
					{
						newY += barriersRect.top - newGuyRect.bottom;
					}
				}
				
			}
			
			// check for collisions with sides
			if ((newGuyRect.right > mapRect.right) && (guyRect.right <= mapRect.right)) 
			{
				newX += mapRect.right - newGuyRect.right;
			}
			if ((newGuyRect.left < mapRect.left) && (guyRect.left >= mapRect.left)) 
			{
				newX += mapRect.left - newGuyRect.left;
			}
			
			if ((newGuyRect.top < mapRect.top) && (guyRect.top >= mapRect.top)) 
			{
				newY += mapRect.top-newGuyRect.top;
			}
			if ((newGuyRect.bottom > mapRect.bottom) && (guyrRect.bottom <= mapRect.bottom)) 
			{
				newY += mapRect.bottom - newGuyRect.bottom;
			}
		
			// set new car location
			gamesprite.guy.x = newX;
			gamesprite.guy.y = newY;
		}
		
		/*// turn car left or right
		// check for collisions with trash and trash cans
		public function checkCollisions() 
		{
			
				
			// loop through trash cans
			for(var i:int=trashObjects.length-1;i>=0;i--) 
			{
		
				// see if close enough to get trash objects
				if (Point.distance(new Point(gamesprite.car.x,gamesprite.car.y), new Point(trashObjects[i].x, trashObjects[i].y)) < pickupDistance) 
				{
						
					// see if there is room
					  if (totalTrashObjects < maxCarry) 
					  {
						// get trash object
						onboard[trashObjects[i].currentFrame-1]++;
						gamesprite.removeChild(trashObjects[i]);
						trashObjects.splice(i,1);
						Score += 10;
						trace(txtScore);
						CornCount -= 1;
						trace(txtCornCount);
						
						txtCornCount = String(CornCount);
						txtScore = String(Score);
						
					
						
						numLeft.text = (txtCornCount);
						scoreDisplay.text = (txtScore);
						
						
						if (CornCount == 0){
							
							trace("You Win");
							showFinalMessage();
						}
			
						
						
					  } 
					else if (trashObjects[i] != lastObject) 
					{
						// playSound(theFullSound);
						 lastObject = trashObjects[i];
					   } 
					}
				}
				

		}
					// check for collisions with pig
		public function checkCollisionsPig() 
		{
			
				
			// loop through trash cans
			for(var p:int=pig.length-1;p>=0;p--) 
			{
		
				// see if close enough to get trash objects
				if (Point.distance(new Point(gamesprite.car.x,gamesprite.car.y), new Point(pig[p].x, pig[p].y)) < pickupDistance) 
				{
						
					// see if there is room
					  if (totalTrashObjects < maxCarry) 
					  {
						// get trash object
						onboard[pig[p].currentFrame-1]++;
						gamesprite.removeChild(pig[p]);
						pig.splice(p,1);
						Score -= 10;
						trace(Score);
						
						txtCornCount = String(CornCount);
						txtScore = String(Score);
						
					
						
						numLeft.text = (txtCornCount);
						scoreDisplay.text = (txtScore);
						
					  } 
					else if (pig[p] != lastObject) 
					{
						// playSound(theFullSound);
						 lastObject = pig[p];
					   } 
					}
				}
				
				
		}
		*/
		
		// game over, remove listeners
		public function endGame() 
		{
			blocks = null;
			//trashObjects = null;
			//trashcans = null;
			this.removeEventListener(Event.ENTER_FRAME,gameLoop);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownFunction);
			stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpFunction);
			gotoAndStop("gameover");
		}
		
		 //show time on final screen
		public function showFinalMessage() 
		{
			gotoAndStop(3);
			testScore.text = String(Score);
		}
		
		
     } 
		
	}
