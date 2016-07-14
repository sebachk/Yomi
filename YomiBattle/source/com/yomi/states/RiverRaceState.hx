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
	
	private static var ACC:Float = 300;
	private static var MAX_VEL:Float = 1000;
	
	private var accActual:Float;
	
	override public function create():Void 
	{
		super.create();
		stones = new FlxSpriteGroup();
		
		for (i in 1...4){
			var stone:FlxSprite = new FlxSprite(0, 0, "assets/images/bocetoTest/StoneSprite.png");
			stone.scale.set(0.2, 0.2);
			stone.updateHitbox();
			stone.kill();
			
			stones.add(stone);
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
		floodTimer.start(5, changeFlow, 0);
		yomi.acceleration.x = -ACC;
		
		leftWall = new FlxSprite();
		leftWall.makeGraphic(10, FlxG.height, 0xFF00FFFF);
		leftWall.x =-leftWall.width * 0.5;
		this.add(leftWall);
		
		rightWall = new FlxSprite();
		rightWall.x = FlxG.width - rightWall.width * 0.5;
		rightWall.makeGraphic(10, FlxG.height, 0xFF00FFFF);
		this.add(rightWall);
		
		FlxG.debugger.visible = true;
		FlxG.debugger.track(yomi.acceleration, "acc");
		
		accActual = ACC;
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
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		
		FlxG.overlap(yomi, leftWall, stageCollision);
		FlxG.overlap(yomi, rightWall, stageCollision);
		
		if (FlxG.mouse.justPressed){
			var vel: Float = 300* FlxMath.numericComparison(FlxG.mouse.x, FlxG.width * 0.5);
			yomi.velocity.x = vel;	
		}
		yomi.acceleration.x = accActual;
		
		yomi.velocity.x = FlxMath.bound(yomi.velocity.x, MAX_VEL *-1, MAX_VEL);
		
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