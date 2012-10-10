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
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.display.Stage;
	
	public class Gamepad
	{
		// INPUTS:
			
		protected var _up:GamepadInput;
		protected var _down:GamepadInput;
		protected var _left:GamepadInput;
		protected var _right:GamepadInput;
		protected var _fire1:GamepadInput;
		protected var _fire2:GamepadInput;
		protected var _fire3:GamepadInput;
		protected var _fire4:GamepadInput;
		protected var _fire5:GamepadInput;
		protected var _fire6:GamepadInput;
		protected var _inputs:Array;
		
		// MULTI-INPUTS (combines 2 or more inputs into 1, e.g. _upLeft requires both up and left to be pressed)
		
		protected var _upLeft:GamepadMultiInput;
		protected var _downLeft:GamepadMultiInput;
		protected var _upRight:GamepadMultiInput;
		protected var _downRight:GamepadMultiInput;
		protected var _anyDirection:GamepadMultiInput;
		protected var _multiInputs:Array;
		
		// THE "STICK"
		
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		protected var _targetX:Number = 0;
		protected var _targetY:Number = 0;
		protected var _angle:Number = 0;
		protected var _rotation:Number = 0;
		protected var _magnitude:Number = 0;
		
		/*
		* Prevents diagonal movement being faster than horizontal or vertical movement. Use for top-down view games.  
		*/
		public var isCircle:Boolean;
		
		/*
		* Simple ease-out speed (range 0 to 1). Pass value of 1 to prevent easing. 
		*/
		public var ease:Number;
		
		/*
		 * Gamepad simplifies keyboard input by simulating an analog joystick.
		 * @param stage A reference to the stage is needed to listen for system events
		 * @param isCircle Prevents diagonal movement being faster than horizontal or vertical movement. Use for top-down view games.
		 * @param ease Simple ease-out speed (range 0 to 1). Pass value of 1 to prevent easing.
		 * @param autoStep Pass in false if you intend to call step() manually.
		*/
		
		public function Gamepad(stage:Stage, isCircle:Boolean, ease:Number = 0.2, autoStep:Boolean = true)
		{
			trace('Remember to hit "Control > Disable Keyboard Shorcuts" in the Flash IDE & stand-alone Flash player!');
			
			this.isCircle = isCircle;
			this.ease = ease;
			
			_up = new GamepadInput();
			_down = new GamepadInput();
			_left = new GamepadInput();
			_right = new GamepadInput();
			_fire1 = new GamepadInput();
			_fire2 = new GamepadInput();
			_fire3 = new GamepadInput();
			_fire4 = new GamepadInput();
			_fire5 = new GamepadInput();
			_fire6 = new GamepadInput();
			
			_inputs = [_up, _down, _left, _right, _fire1, _fire2, _fire3, _fire4, _fire5, _fire6];
			
			_upLeft = new GamepadMultiInput([_up, _left], false);
			_upRight = new GamepadMultiInput([_up, _right], false);
			_downLeft = new GamepadMultiInput([_down, _left], false);
			_downRight = new GamepadMultiInput([_down, _right], false);
			_anyDirection = new GamepadMultiInput([_up, _down, _left, _right], true);
			
			_multiInputs = [_upLeft, _upRight, _downLeft, _downRight, _anyDirection];
			
			useArrows();
			useWASD();
			useZXCSpace();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp, false, 0, true);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, 0, true);
			
			if (autoStep)
			{
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame, false, 0, true);
			}
		}
		
		/*
		 * Reset the state of the gamepad, so no buttons are pressed. Use for restarting levels etc, where gamepad may have picked up unwanted commands during menus.
		 */
		
		public function resetState():void
		{
			for each (var input:GamepadInput in _inputs)
			{
				input.resetState();
			}
			
			_x = 0;
			_y = 0;
			_targetX = 0;
			_targetY = 0;
			_angle = 0;
			_rotation = 0;
			_magnitude = 0;
		}
		
		// DIRECTION PRESETS
		
		/*
		 * Quickly map all direction keys
		 * @param up Keycode - use the constants from com.cheezeworld.utils.KeyCode.
		 * @param down Keycode - use the constants from com.cheezeworld.utils.KeyCode.
		 * @param left Keycode - use the constants from com.cheezeworld.utils.KeyCode.
		 * @param right Keycode - use the constants from com.cheezeworld.utils.KeyCode.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys.
		 */
		
		public function mapDirection(up:int, down:int, left:int, right:int, replaceExisting:Boolean = false):void
		{
			_up.mapKey(up, replaceExisting);
			_down.mapKey(down, replaceExisting);
			_left.mapKey(left, replaceExisting);
			_right.mapKey(right, replaceExisting);
		}
		
		/*
		 * Preset to use the direction arrow keys for movement
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useArrows(replaceExisting:Boolean = false):void
		{
			mapDirection(Keyboard.UP, Keyboard.DOWN, Keyboard.LEFT, Keyboard.RIGHT, replaceExisting);
		}
		
		/*
		 * Preset to use the W, A, S and D keys for movement. This layout doesn't work for players with French AZERTY keyboards - call useZQSD() instead.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useWASD(replaceExisting:Boolean = false):void
		{
			mapDirection(KeyCode.W, KeyCode.S, KeyCode.A, KeyCode.D, replaceExisting);
		}
		
		/*
		 * Preset to use the I, J, K and L keys for movement.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useIJKL(replaceExisting:Boolean = false):void
		{
			mapDirection(KeyCode.I, KeyCode.K, KeyCode.J, KeyCode.L, replaceExisting);
		}
		
		/*
		 * Preset to use the Z, Q, S and D keys for movement. Use this mapping instead of useWASD() when targeting French AZERTY keyboards.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useZQSD(replaceExisting:Boolean = false):void
		{
			mapDirection(KeyCode.Z, KeyCode.S, KeyCode.Q, KeyCode.D, replaceExisting);
		}
		
		// FIRE BUTTON PRESETS
		
		/*
		 * Map the fire buttons.
		 * @param fire1 The primary fire button.
		 * @param fire2 The secondary fire button.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function mapFireButtons(fire1:int, fire2:int, fire3:int, fire4:int, fire5:int, fire6:int, replaceExisting:Boolean = false):void
		{
			_fire1.mapKey(fire1, replaceExisting);
			_fire2.mapKey(fire2, replaceExisting);
			_fire3.mapKey(fire3, replaceExisting);
			_fire4.mapKey(fire4, replaceExisting);
			_fire5.mapKey(fire5, replaceExisting);
			_fire6.mapKey(fire6, replaceExisting);
		}
		
		/*
		 * Preset to use the < and > keys for fire buttons.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useChevrons(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.LESS_THAN, KeyCode.GREATER_THAN, KeyCode.LESS_THAN, KeyCode.GREATER_THAN, KeyCode.LESS_THAN, KeyCode.GREATER_THAN, replaceExisting);
		}
		
		/*
		 * Preset to use the G and H keys for fire buttons.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useGH(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.G, KeyCode.H, KeyCode.G, KeyCode.H, KeyCode.G, KeyCode.H, replaceExisting);
		}
		
		/*
		 * Preset to use the Z and X keys for fire buttons.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useZX(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.Z, KeyCode.X, KeyCode.Z, KeyCode.X, KeyCode.Z, KeyCode.X, replaceExisting);
		}
		
		/*
		 * Preset to use the Z, X, C and Space keys for fire buttons.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useZXCSpace(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.Z, KeyCode.X, KeyCode.C, KeyCode.SPACEBAR, KeyCode.ENTER, KeyCode.ENTER, replaceExisting);
		}
		
		/*
		 * Preset to use the Y and X keys for fire buttons.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useYX(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.Y, KeyCode.X, KeyCode.Y, KeyCode.X, KeyCode.Y, KeyCode.X, replaceExisting);
		}
		
		/*
		 * Preset to use the CTRL and SPACEBAR keys for fire buttons.
		 * @param replaceExisting pass true to replace exisiting keys, false to add mapping without replacing existing keys. 
		 */
		
		public function useControlSpace(replaceExisting:Boolean = false):void
		{
			mapFireButtons(KeyCode.CONTROL, KeyCode.SPACEBAR, KeyCode.CONTROL, KeyCode.SPACEBAR, KeyCode.CONTROL, KeyCode.SPACEBAR, replaceExisting);
		}
		
		/*
		 * Copy mapping from another Gamepad.
		 */
		
		public function copyMapping(gamepad:Gamepad):void
		{
			_fire1.copyMapping(gamepad.fire1);
			_fire2.copyMapping(gamepad.fire2);
			_fire3.copyMapping(gamepad.fire3);
			_fire4.copyMapping(gamepad.fire4);
			_fire5.copyMapping(gamepad.fire5);
			_fire6.copyMapping(gamepad.fire6);
			
			_up.copyMapping(gamepad.up);
			_down.copyMapping(gamepad.down);
			_left.copyMapping(gamepad.left);
			_right.copyMapping(gamepad.right);
		}
		
		// UPDATE:
		
		/*
		 * Step/Update the gamepad. Called automatically if you didn't pass in autoStep as false. This should be called in sync with you game/physics step.
		*/
		
		public function step():void
		{
			_x += (_targetX - _x) * ease;
			_y += (_targetY - _y) * ease;
			
			_magnitude = Math.sqrt((_x * _x) + (_y * _y));
			
			_angle = Math.atan2(_x, _y);
			
			_rotation = _angle * 57.29577951308232;
			
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.update();
		}
		
		// SETTERS:
		
		/*
		* The horizontal component of the direction pad, value between 0 and 1.
		*/
		public function set x(value:Number):void
		{ 
			_x = value;
			_targetX = value;
			_angle = Math.atan2(_x, _y);
			_rotation = _angle * 57.29577951308232;
		}
		
		/*
		* The vertical component of the direction pad, value between 0 and 1.
		*/
		public function set y(value:Number):void
		{ 
			_y = value;
			_targetY = value;
			_angle = Math.atan2(_x, _y);
			_rotation = _angle * 57.29577951308232;
		}
		
		// GETTERS:
		
		/*
		* The angle of the direction pad in radians.
		*/
		public function get angle():Number { return _angle; }
		
		/*
		* The horizontal component of the direction pad, value between 0 and 1.
		*/
		public function get x():Number { return _x; }
		
		/*
		* The vertical component of the direction pad, value between 0 and 1.
		*/
		public function get y():Number { return _y; }
		
		/*
		* A GamepadInput representing the up/north direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get up():GamepadInput { return _up; }
		
		/*
		* A GamepadInput representing the down/south direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get down():GamepadInput { return _down; }
		
		/*
		* A GamepadInput representing the left/west direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get left():GamepadInput { return _left; }
		
		/*
		* A GamepadInput representing the right/east direction. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get right():GamepadInput { return _right; }
		
		/*
		* A GamepadMultiInput representing the up-left/north-west direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
		*/
		public function get upLeft():GamepadMultiInput { return _upLeft; }
		
		/*
		* A GamepadMultiInput representing the down-left/south-west direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
		*/
		public function get downLeft():GamepadMultiInput { return _downLeft; }
		
		/*
		* A GamepadMultiInput representing the up-right/north-east direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
		*/
		public function get upRight():GamepadMultiInput { return _upRight; }
		
		/*
		* A GamepadMultiInput representing the down-right/south-east direction. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
		*/
		public function get downRight():GamepadMultiInput { return _downRight; }
		
		/*
		* A GamepadInput representing the primary fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get fire1():GamepadInput { return _fire1; }
		
		/*
		* A GamepadInput representing the secondary fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get fire2():GamepadInput { return _fire2; }
		
		/*
		* A GamepadInput representing the third fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get fire3():GamepadInput { return _fire3; }
		
		/*
		* A GamepadInput representing the forth fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get fire4():GamepadInput { return _fire4; }
		
		/*
		* A GamepadInput representing the fith fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get fire5():GamepadInput { return _fire5; }
		
		/*
		* A GamepadInput representing the fith fire button. Configure with its mapKey and unmapKey functions. Get state information from isDown, isPressed, isReleased, downTicks and upTicks.  
		*/
		public function get fire6():GamepadInput { return _fire6; }
		
		/*
		* A special GamepadMultiInput representing whether any direction is pressed. Get state information from isDown, isPressed, isReleased, downTicks and upTicks. End-users should not need to configure this input.
		*/
		public function get anyDirection():GamepadMultiInput { return _anyDirection; }
		
		/*
		 * The length/magnitude of the direction pad, between 0 and 1.
		*/
		public function get magnitude():Number { return _magnitude; }
		
		/*
		 * the angle of the direction pad in degrees, between 0 and 360.
		*/
		public function get rotation():Number { return _rotation; }
		
		// PROTECTED METHODS:
		
		protected function onEnterFrame(event:Event):void
		{
			step();
		}
		
		protected function onKeyDown(event:KeyboardEvent):void
		{
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.keyDown(event.keyCode);
			
			updateState();
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.keyUp(event.keyCode);
			
			updateState();
		}
		
		protected function onMouseDown(event:MouseEvent):void
		{
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.mouseDown();
			
			updateState();
		}
		
		protected function onMouseUp(event:MouseEvent):void
		{
			for each (var gamepadInput:GamepadInput in _inputs) gamepadInput.mouseUp();
			
			updateState();
		}
		
		protected function onMouseWheel(event:MouseEvent):void
		{
			var gamepadInput:GamepadInput;
			
			if (event.delta > 0)
			{
				for each (gamepadInput in _inputs) gamepadInput.mouseWheelUp();
			}
			else
			{
				for each (gamepadInput in _inputs) gamepadInput.mouseWheelDown();
			}
			
			updateState();
		}
		
		protected function updateState():void
		{
			for each (var gamepadMultiInput:GamepadMultiInput in _multiInputs) gamepadMultiInput.update();
			
			if (_up.isDown)
			{
				_targetY = -1;
			}
			else if (_down.isDown)
			{
				_targetY = 1;
			}
			else
			{
				_targetY = 0;
			}
			
			if (_left.isDown)
			{
				_targetX = -1;
			}
			else if (_right.isDown)
			{
				_targetX = 1;
			}
			else
			{
				_targetX = 0;
			}
			
			var _targetAngle:Number = Math.atan2(_targetX, _targetY);
			
			if (isCircle && _anyDirection.isDown)
			{
				_targetX = Math.sin(_targetAngle);
				_targetY = Math.cos(_targetAngle);
			}
		}
	}
}