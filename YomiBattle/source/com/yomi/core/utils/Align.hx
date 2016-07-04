package com.yomi.core.utils;
import flixel.FlxObject;
import flixel.FlxG;
/**
 * ...
 * @author ...
 */
class Align
{
	public static function right( hijo:FlxObject,?padre:FlxObject):Float{
		if (padre == null){
			return FlxG.width - hijo.width;	
		}
		
		return padre.width - hijo.width;
	}
	
	public static function bottom(hijo:FlxObject, ?padre:FlxObject):Float{
		if (padre == null){
			return FlxG.height - hijo.height;	
		}
		return padre.height - hijo.height;
	}
	
	public static function midX(hijo:FlxObject, ?padre:FlxObject):Float{
		return right(hijo, padre)*0.5;
	}
	
	public static function midY(hijo:FlxObject, ?padre:FlxObject):Float{
		return bottom(hijo, padre)*0.5;
	}
}