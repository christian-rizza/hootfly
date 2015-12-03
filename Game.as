package  {
	
	import flash.display.MovieClip;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.SoundMixer;
	import flash.utils.setInterval;
	import flash.display.DisplayObject;
	
	public class Game extends Sprite
	{
		public static const MARGIN_X:int = 50;
		public static const MARGIN_Y:int = 50;
		public static var WIDTH:int = 1024;
		public static var HEIGHT:int = 768;
		private const MIN_SPEED:Number = 1500;
		
		//Define delta time
		private var time_previous:Number;
		private var time_current:Number;
		private var time_elapsed:Number;
		
		private var score_distance:int;
		private var obstacle_gap_count:int;
		private var obstacle_to_animate:Vector.<Enemy>;
		private var game_area:Rectangle;
		
		private var playButton:Sprite;
		private var player:Owl;
		private var bg:GameBackground;
		
		private var game_state:String;			//Stato di gioco
		private var player_speed:Number = 0;	//Velocita del player
		private var hitObjstacle:Number = 0;	//Collisioni
		
		private var life=3;
		
		private var gameChannel:SoundChannel;
		private var s:Sound;
		
		public function Game() 
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			KeyManager.init(stage);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			
			playButton = this.btnPlay;
			playButton.buttonMode=true;
			playButton.addEventListener(MouseEvent.CLICK, playClicked);

			s = new OwlSound();
			
			bg = gameBackGround;
			player = owl;
			
			txtScore.visible=false;
		}
		
		private function checkElapsed():void
		{
			time_previous = time_current;
			time_current = getTimer();
			time_elapsed = (time_current-time_previous)*0.001;
		}
		
		private function update(e:Event):void
		{
			checkElapsed();
			
			switch(game_state)
			{
				case GameState.IDLE:
					break;
				case GameState.GAME:
			
					txtScore.text = "Score: "+score_distance;
					if (life<=0)
					{
						game_state = GameState.OVER;
						break;
					}
				
					if (hitObjstacle<=0)
					{
						KeyManager.enable();
					}
					else
					{
						KeyManager.disable();
					}
					
					player_speed -= (player_speed-MIN_SPEED) * 0.01;
					bg.speed = player_speed*time_elapsed;
					score_distance += (player_speed * time_elapsed) * 0.1;
					initEnemies();
					animateEnemies();
					checkLife();
					break;
				case GameState.OVER:
					
					KeyManager.disable();
				
					for (var i:int = 0; i < obstacle_to_animate.length; i++) 
					{
						if (obstacle_to_animate[i])
						{
							obstacle_to_animate[i].destroy();
						}
					}
					obstacle_to_animate = new Vector.<Enemy>();
					
					player_speed=0;
					bg.speed = 0;
					
					TweenLite.to(playButton, 0.5, {x: 427.2, y:432.75});
					TweenLite.to(player, 0.5, {x: 512, y: 320.25});
					setTimeout(function():void
					{
						TweenLite.to(player, 0.5, {scaleX: 1, scaleY: 1});
						TweenLite.to(txtScore, 0.5, {x:400, y:500});
					},500);
					
					life=3;
					game_state = GameState.IDLE;
					hitObjstacle=0;
					
					s.play();
					gameChannel.stop();
					titolo.visible=true;
					titolo.sottotitolo.visible=false;
					//tutorial.visible=true;
					
					break;
			}
		}
		private function checkLife():void
		{
			if (life==0) life3.visible=false;
			if (life==1) life2.visible=false;
			if (life==2) life1.visible=false;
		}
		//Creo i nemici
		private function initEnemies():void
		{
			if (obstacle_gap_count<500)
			{
				obstacle_gap_count += player_speed*time_elapsed;
			}
			else if(obstacle_gap_count!=0)
			{
				obstacle_gap_count = 0;
				createEnemy(Math.random()*1000);
			}
		}
		private function animateEnemies():void
		{
			var temp:Enemy;
			
			for (var i:int = 0; i < obstacle_to_animate.length; i++) 
			{
				temp = obstacle_to_animate[i];
				checkCollide(temp, player);
				moveObstacle(temp);
				
				if (temp.x < -temp.width || game_state==GameState.OVER)
				{
					obstacle_to_animate.splice(i, 1);
					temp.destroy();
				}
			}
		}
		private function checkCollide(item1:Enemy, item2:Owl):void
		{
			// Collision detection - Check if the hero eats a food item.
			var heroItem_xDist:Number = item1.x - item2.x;
			var heroItem_yDist:Number = item1.y - item2.y+50;
			var heroItem_sqDist:Number = heroItem_xDist * heroItem_xDist + heroItem_yDist * heroItem_yDist;
			
			//if (item1.alreadyHit==false && item1.bounds.intersects(item2.bounds))
			if (item1.alreadyHit==false && (heroItem_sqDist < 7000))
			{
				item1.alreadyHit = true;
				
				if (item1.position=="top") item1.rotation = deg2rad(55);
				else if (item1.position=="bottom") item1.rotation = deg2rad(-55);
				else if (item1.position=="middle") item1.rotation = deg2rad(item1.y>item2.y ? -15 : 15);
				
				if (item2==player)
				{
					hitObjstacle = 50;
					player_speed *= 0.5;
					life--;
					
					var s:Sound = new BoingSound();
					s.play();
				}
			}
			else
			{
				hitObjstacle--;
				cameraShake();
			}
			
		}
		private function cameraShake():void
		{
			if (hitObjstacle>0)
			{
				this.x = Math.random()*10;
				this.y = Math.random()*10;
				
			}
			else if (x!=0)
			{
				this.x =0;
				this.y =0;				
			}
		}
		private function moveObstacle(temp:Enemy)
		{
			if (temp.distance>0)
			{
				temp.distance -= player_speed*time_elapsed;
			}
			else
			{						
				if (temp.y < Game.MARGIN_Y - temp.height/2 || temp.y > Game.HEIGHT - Game.MARGIN_Y)
				{
					temp.explosion = true;
				}
				
				if (!temp.explosion)
				{
					temp.x -= (player_speed+temp.speed)*time_elapsed;
					
					if (temp.rotation < deg2rad(0))
					{
						temp.y += (player_speed+temp.speed)*time_elapsed;
					}
					else if (temp.rotation > deg2rad(0))
					{
						temp.y -= (player_speed+temp.speed)*time_elapsed;
					}
				}
				else
				{
					temp.x -= player_speed*time_elapsed;
				}
				
			}
		}
		private function playClicked(e:MouseEvent):void
		{
			TweenLite.to(playButton, 0.5, {y: stage.stageHeight+playButton.height});
			TweenLite.to(player, 0.5, {scaleX: 0.5, scaleY: 0.5});
			TweenLite.to(txtScore, 0.5, {x:20, y:15});
			
			s.play();
			
			life1.visible=true;
			life2.visible=true;
			life3.visible=true;
			
			tutorial.visible=false;
			titolo.visible=false;
			score_distance = 0;
			txtScore.visible=true;
			txtScore.text = "Score: 0";
			
			setTimeout(function():void
			{
				startGame();
				var gameSound=new GameSound();
				gameChannel = gameSound.play(0,10000);
				
			}, 2000);
			
			
		}
		private function startGame():void
		{
			TweenLite.to(player, 0.5, {x: 100, y: stage.stageHeight/2+player.height/2});
			
			obstacle_to_animate = new Vector.<Enemy>();
			game_area = new Rectangle(0,100,stage.stageWidth, stage.stageHeight-100);
			game_state = GameState.GAME;
		}
		
		public function deg2rad(deg:Number):Number
		{
			return deg / 180.0 * Math.PI;   
		}
	
		private function createEnemy(distance:Number):void
		{
			var obstacle:Enemy = new Enemy(distance);
			this.addChild(obstacle);
			
			obstacle.x = stage.stageWidth+obstacle.width;
			
			var random:Number = Math.random();
			/*if (random>0.2)
			{
				obstacle.y = game_area.top;
				obstacle.position = "top";
			}
			else if (random>0.4)*/
			{
				
				obstacle.y = int(Math.random()*(game_area.bottom-obstacle.height-game_area.top))+game_area.top;
				obstacle.position = "middle";				
			}
			/*else
			{
				obstacle.y = game_area.bottom-obstacle.height;
				obstacle.position = "bottom";
			}*/
			
			obstacle_to_animate.push(obstacle);
		}
		
	}
	
}
