package engine  
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Iain Lobb - iainlobb@gmail.com
	 */
	public interface IEntity 
	{
		// ACTIONS
		function destroy():void;
		function update():void;
		function render():void;
		
		// COMPONENTS
		function get body():Body;
		function set body(value:Body):void;
		function get physics():Physics; 
		function set physics(value:Physics):void 
		function get health():Health 
		function set health(value:Health):void
		function get weapon():Weapon; 
		function set weapon(value:Weapon):void;
		function get view():View; 
		function set view(value:View):void; 
		
		// SIGNALS
		function get entityCreated():Signal; 
		function set entityCreated(value:Signal):void;
		function get destroyed():Signal; 
		function set destroyed(value:Signal):void; 
		
		// DEPENDANCIES
		function get targets():Vector.<Entity>; 
		function set targets(value:Vector.<Entity>):void;
		function get group():Vector.<Entity>; 
		function set group(value:Vector.<Entity>):void; 
	}
	
}