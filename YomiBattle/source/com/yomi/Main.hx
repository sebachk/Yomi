package com.yomi;

import com.yomi.states.RiverRaceState;
import flixel.FlxGame;
import openfl.display.Sprite;
import com.yomi.states.FallingFruitState;
class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, RiverRaceState));
	}
}