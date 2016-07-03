package com.yomi;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class MenuState extends FlxState
{
	private var text:FlxText;
	
	override public function create():Void
	{
		super.create();
		text = new FlxText(0, 0, 0, "Hola Mundo Yomi");
		//text.color = FlxColor.BLUE;
		this.add(text);
		
		#if html5 
		text.color = FlxColor.RED;
		#end
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	
		if (FlxG.mouse.justPressed){
			text.x = FlxG.mouse.x;
			text.y = FlxG.mouse.y;
		}
	}
}