/*
Copyright (c) 2010 Iain Lobb - iainlobb@gmail.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/

package com.iainlobb.gamepad 
{
	public class GamepadInput
	{
		protected var _isDown:Boolean;
		protected var _isPressed:Boolean;
		protected var _isReleased:Boolean;
		protected var _downTicks:int = -1;
		protected var _upTicks:int = -1;
		public var mappedKeys:Array;
		protected var hasMouse:Boolean;
		protected var hasMouseWheelUp:Boolean;
		protected var hasMouseWheelDown:Boolean;
		protected var isWheelingUp:Boolean;
		protected var isWheelingDown:Boolean;
		
		/*
		* Represents a gamepad button - can be mapped to more than 1 physical key simultaneously, allowing multiple redundant control schemes.  
		*/
		public function GamepadInput(keyCode:int = -1) 
		{
			mappedKeys = (keyCode > -1) ? [keyCode] : [];
		}
		
		/*
		* Map a physical key to this virtual button.
		* @param keyCode Use the constants from com.cheezeworld.utils.KeyCode.
		* @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
		*/
		public function mapKey(keyCode:int, replaceExisting:Boolean = false):void
		{
			if (replaceExisting)
			{
				mappedKeys = [keyCode];
				hasMouse = false;
				hasMouseWheelUp = false;
				hasMouseWheelDown = false;
			}
			else if (mappedKeys.indexOf(keyCode) == -1)
			{
				mappedKeys.push(keyCode);
			}
		}
		
		/*
		* Map a physical key to this virtual button.
		* @param keyCode Use the constants from com.cheezeworld.utils.KeyCode.
		* @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
		*/
		public function mapMouse(replaceExisting:Boolean = false):void
		{
			if (replaceExisting)
			{
				mappedKeys = [];
				hasMouseWheelUp = false;
				hasMouseWheelDown = false;
			}
			
			hasMouse = true;
		}
		
		/*
		* Map a physical key to this virtual button.
		* @param keyCode Use the constants from com.cheezeworld.utils.KeyCode.
		* @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
		*/
		public function mapMouseWheelUp(replaceExisting:Boolean = false):void
		{
			if (replaceExisting)
			{
				mappedKeys = [];
				hasMouse = false;
				hasMouseWheelDown = false;
			}
			
			hasMouseWheelUp = true;
		}
		
		/*
		* Map a physical key to this virtual button.
		* @param keyCode Use the constants from com.cheezeworld.utils.KeyCode.
		* @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
		*/
		public function mapMouseWheelDown(replaceExisting:Boolean = false):void
		{
			if (replaceExisting)
			{
				mappedKeys = [];
				hasMouse = false;
				hasMouseWheelUp = false;
			}
			
			hasMouseWheelDown = true;
		}
		
		/*
		* Copy mapping from another GamepadInput.
		*/
		public function copyMapping(gamepadInput:GamepadInput):void
		{
			mappedKeys = [];
			
			for each (var keyCode:int in gamepadInput.mappedKeys) mappedKeys.push(keyCode);
		}
		
		/*
		* Unmap a physical key from this virtual button.
		* @param keyCode Use the constants from com.cheezeworld.utils.KeyCode.
		*/
		public function unmapKey(keyCode:int):void
		{
			mappedKeys.splice(mappedKeys.indexOf(keyCode), 1);
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function update():void
		{
			if (hasMouseWheelUp && !isWheelingUp) _isDown = false;
			if (hasMouseWheelDown && !isWheelingDown) _isDown = false;
			
			if (isWheelingUp || isWheelingDown) _isDown = true;
			
			if (_isDown)
			{
				_isPressed = _downTicks == -1;
				_isReleased = false;
				_downTicks++;
				_upTicks = -1;
			}
			else
			{
				_isReleased = _upTicks == -1;
				_isPressed = false;
				_upTicks++;
				_downTicks = -1;
			}

			isWheelingDown = false;
			isWheelingUp = false;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function keyDown(keyCode:int):void
		{
			if (mappedKeys.indexOf(keyCode) > -1) _isDown = true;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function keyUp(keyCode:int):void
		{
			if (mappedKeys.indexOf(keyCode) > -1) _isDown = false;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function mouseDown():void
		{
			if (hasMouse) _isDown = true;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function mouseUp():void
		{
			if (hasMouse) _isDown = false;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function mouseWheelUp():void
		{
			if (hasMouseWheelUp) isWheelingUp = true;
		}
		
		/*
		* Called by owner Gamepad. End users should not call this function.
		*/
		public function mouseWheelDown():void
		{
			if (hasMouseWheelDown) isWheelingDown = true;
		}
		
		/*
		 * Called by owner Gamepad. End users should not call this function.
		 */
		
		public function resetState():void
		{
			_isDown = false;
			_isPressed = false;
			_isReleased = false;
			_downTicks = 0;
			_upTicks = 0;
		}
		
		/*
		 * Is this input currently held down. 
		 */
		public function get isDown():Boolean { return _isDown; }
		
		/*
		 * Was this input pressed this frame/step - use instead of listening to key down events.
		 */
		public function get isPressed():Boolean { return _isPressed; }
		
		/*
		 * Was this input released this frame/step - use instead of listening to key up events.
		 */
		public function get isReleased():Boolean { return _isReleased; }
		
		/*
		 * How long has the input been held down.
		 */
		public function get downTicks():int { return _downTicks; }
		
		/*
		 * How long since the input was last released.
		 */
		public function get upTicks():int { return _upTicks; }
	}
}