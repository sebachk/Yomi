package com.yomi.states;

import com.yomi.core.utils.Align;
import flixel.FlxG;
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
	
	private static var ACC:Float = 300;
	
	
	override public function create():Void 
	{
		super.create();
		stones = new FlxSpriteGroup();
		
		for (i in 1...4){
			var stone:FlxSprite = new FlxSprite(0, 0, "assets/images/bocetoTest/StoneSprite.png");
			stone.kill();
			stones.add(stone);
		}
		
		yomi = new FlxSprite(0, 0, "assets/images/bocetoTest/yomiFront.png");
		//creado
		yomi.scale.set(0.1, 0.1);
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
		FlxG.debugger.visible = true;
		FlxG.debugger.track(yomi.acceleration, "acc");
	}
	
	
	private function addStone(timer:FlxTimer){
		
		var stone:FlxSprite=this.stones.getFirstDead(); // Obtiene la primer piedra que esta en pantalla;
		
		stone.x = FlxMath.lerp(0, FlxG.width, Math.random());
		
		stone.y = -200;
		
		stone.velocity.y = 100; 
		
		this.add(stone);
		stone.revive();
	}
	
	private function changeFlow(timer:FlxTimer){
		yomi.acceleration.x = ACC;
		if(timer.elapsedLoops%2==0){
			yomi.acceleration.x *=-1;
		}
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.mouse.justPressed){
			var vel: Float = 200* FlxMath.numericComparison(FlxG.mouse.x, FlxG.width * 0.5);
			yomi.velocity.x = vel;
			
		}
		
		
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
	
}