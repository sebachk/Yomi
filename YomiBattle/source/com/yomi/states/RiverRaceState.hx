package com.yomi.states;

import com.yomi.core.utils.Align;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxTimer;

/**
 * MiniJuego del rio
 * @author Sebachk
 */
class RiverRaceState extends FlxState
{

	private var stones:FlxSpriteGroup;
	private var yomi:FlxSprite;
	
	private var floodTimer:FlxTimer;
	private var stoneTimer:FlxTimer;
	private var fuerzaCorriente:Int;
	
	private var leftWall:FlxSprite;
	private var rightWall:FlxSprite;
	
	private static var MAX_ACC:Float = 80;
	private static var MAX_VEL:Float = 200;
	
	private var accActual:Float;
	
	private var background:FlxSpriteGroup;
	
	override public function create():Void 
	{
		super.create();
		stones = new FlxSpriteGroup();
		
		for (i in 1...4){
			var stone:FlxSprite = new FlxSprite(0, 0, "assets/images/bocetoTest/StoneSprite.png");
			stone.scale.set(0.4, 0.4);
			stone.updateHitbox();
			stone.kill();
			
			stones.add(stone);
		}
		
		background = new FlxSpriteGroup();
		for (i in 0...3){
			var back:FlxSprite = new FlxSprite(0, 0, "assets/images/bocetoTest/water.png");
			back.y =-i * back.height;
			background.add(back);
			this.add(back);
			back.velocity.y = 100;
		}
		
		yomi = new FlxSprite(0, 0, "assets/images/bocetoTest/yomiFront.png");
		//creado
		yomi.scale.set(0.05, 0.05);
		yomi.updateHitbox();
		yomi.x = Align.midX(yomi);
		yomi.y = Align.bottom(yomi);
		//posicionado (abajo al medio)
		this.add (yomi);
		//agregado
		
		stoneTimer = new FlxTimer();
		stoneTimer.start(3, addStone, 0);
		
		floodTimer = new FlxTimer();
		floodTimer.start(15, changeFlow, 0);
		
		
		leftWall = new FlxSprite();
		leftWall.makeGraphic(10, FlxG.height, 0xFF00FFFF);
		leftWall.x =-leftWall.width * 0.5;
		this.add(leftWall);
		
		rightWall = new FlxSprite();
		rightWall.makeGraphic(10, FlxG.height, 0xFF00FFFF);
		rightWall.x = FlxG.width - rightWall.width * 0.5;
		this.add(rightWall);
		
		#if !FLX_NO_DEBUG
			FlxG.debugger.visible = true;
			FlxG.debugger.track(yomi.acceleration, "acc");
		#end
		
		accActual = 10;
	}
	
	
	private function addStone(timer:FlxTimer){
		
		var stone:FlxSprite=this.stones.getFirstDead(); // Obtiene la primer piedra que esta en pantalla;
		
		stone.x = FlxG.random.float(0,FlxG.width-stone.width);
		
		stone.y = -200;
		
		stone.velocity.y = 100; 
		
		this.add(stone);
		stone.revive();
	}
	
	private function changeFlow(timer:FlxTimer){
		
		accActual *=-1;
		for (back in background){
			back.flipY = !back.flipY;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		FlxG.overlap(yomi, leftWall, stageCollision);
		FlxG.overlap(yomi, rightWall, stageCollision);
		
		var acc:Float = yomi.acceleration.x;
		acc += accActual;
		var accMax:Float = MAX_ACC;
		if (FlxG.mouse.justPressed && yomi.velocity.x==0){
			yomi.velocity.x = 10* FlxMath.numericComparison(FlxG.mouse.x, FlxG.width * 0.5);
		}
		if (FlxG.mouse.pressed){
			acc+= 20* FlxMath.numericComparison(FlxG.mouse.x, FlxG.width * 0.5);
			accMax *= 2;
			
		}
		yomi.acceleration.x = FlxMath.bound(acc, accMax *-1, accMax);
		
		//yomi.velocity.x = FlxMath.bound(yomi.velocity.x, MAX_VEL *-1, MAX_VEL);
		
		stones.forEachAlive(function (stone:FlxSprite){
			if (stone.y > FlxG.height){
				stone.kill();//setea el objeto en "muerto" y lo saca de pantalla
			}
			
		});
		
		if (yomi.overlaps(stones)){
			
			var text:FlxText = new FlxText(yomi.x, yomi.y, 0, "PERDIO", 50); 
			yomi.kill();
			this.add(text);
		}
		
		
		for (back in background){
			if (back.y > back.height){
				back.y = back.height *-(background.members.length-1);
			}
		}
	}
	
	private function stageCollision(Object1:FlxObject, Object2:FlxObject):Void
	{
		
		yomi.velocity.x = 0;
		
		if (Object2 == rightWall){
			yomi.x = Object2.x - yomi.width;
		}else{
			yomi.x = Object2.x + Object2.width;
		}
	}
	
}