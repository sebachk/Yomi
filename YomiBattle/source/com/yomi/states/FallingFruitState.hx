package com.yomi.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import com.yomi.core.utils.Align;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.macro.Type.MethodKind;

/**
 * ...
 * @author Tarta CEO de TartaCorp
 */
class FallingFruitState extends FlxState
{
	private var yomi:FlxSprite;
	private var fruits:List<FlxSprite>;
	private var leftArrow:FlxSprite;
	private var rightArrow:FlxSprite;
	private var background:FlxSprite;
	private var timer : Float;
	private var timerMax : Float = 2;
	private var fallingFruits: FlxSpriteGroup;
	private var puntaje : FlxText;
	private var puntajeAux : Int;
	
	override public function create():Void 
	{
		super.create();
		
		//fondo
		var backGround = new FlxSprite();
		backGround.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLUE);
		add(backGround);
		
		yomi = new FlxSprite(0, 0, "assets/images/bocetoTest/yomiFront.png");
		//creado
		yomi.scale.set(0.1, 0.1);
		yomi.updateHitbox();
		yomi.x = Align.midX(yomi);
		yomi.y = Align.bottom(yomi);
		//posicionado (abajo al medio)
		this.add (yomi);
		//agregado
		
		leftArrow = new FlxSprite(0, 0, "assets/images/bocetoTest/leftArrow.png");
		rightArrow = new FlxSprite(0, 0, "assets/images/bocetoTest/rightArrow.png");
		leftArrow.y = Align.bottom(leftArrow);
		rightArrow.y = Align.bottom(rightArrow);
		rightArrow.x = Align.right(rightArrow);
		this.add (leftArrow);
		this.add (rightArrow);
		
		timer = 0;
				
		//fruta
		fallingFruits = new FlxSpriteGroup();
		fruits = new List();
		var fruit : FlxSprite = null; 
			
		for (i in 0 ... 9) {
			var i : Float = Math.random();
			if (i < 0.33){
				fruit = new FlxSprite(0, 0, "assets/images/bocetoTest/appleFruit.png");
			}
			else if (i < 0.66){
				fruit = new FlxSprite(0, 0, "assets/images/bocetoTest/orangeFruit.png");
			}
			else if (i < 1){
				fruit = new FlxSprite(0, 0, "assets/images/bocetoTest/lemonFruit.png");
			}
		fruits.add(fruit);
		}
		
		//puntaje 
		puntajeAux = 0;
		puntaje = new FlxText("0");
		this.add(puntaje);
		
		
	}
	
	
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		var acc:Float = 0;
		
		
		
		if (FlxG.mouse.pressed) {
			if (FlxG.mouse.overlaps(rightArrow)){
				yomi.x  = yomi.x + 10;
			}
			if (FlxG.mouse.overlaps(leftArrow)){
				yomi.x  = yomi.x - 10;
			}
			if (yomi.x < 0)
				yomi.x = 0;
			if (FlxG.width < yomi.getHitbox().right)
				yomi.x = Align.right(yomi);
			
		}
		
		
		//frutas cayendo
		timer = timer + elapsed;
		if (timerMax < timer){
			var fallingFruit : FlxSprite = fruits.pop();
			fallingFruit.x = Align.right(fallingFruit) * Math.random();
			fallingFruits.add(fallingFruit);
			this.add(fallingFruit);
			timer = 0;
			fallingFruit.acceleration.y = 480;
		}
		
		if (yomi.overlaps(fallingFruits)){
			fruits.add(fallingFruits.getFirstAlive());
			puntajeAux = puntajeAux +3;
			puntaje.text = puntajeAux + "";
		}
		
		//for (fallingFruits In ... 
		
		
		
		
		
		if (FlxG.keys.pressed.R)
		{
			FlxG.resetState();
		}
		
		
		
	}
	
}