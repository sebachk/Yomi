package com.yomi;

import flixel.FlxGame;
import openfl.display.Sprite;
import com.yomi.states.FallingFruitState;
class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, FallingFruitState));
		//Comentario Importante del Tarta
	}
}