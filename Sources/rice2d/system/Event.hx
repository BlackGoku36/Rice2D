
	/**
	* This event is taken from https://github.com/armory3d/armory/blob/master/Sources/armory/system/Event.hx
	* Lubos Lenco is original author.
	*/

package rice2d.system;

class Event {

	static var events = new Map<String, Array<TEvent>>();

	/**
	 * Send event of name
	 * @param name Name of event
	 * @param mask = -1
	 */
	public static function send(name:String, mask = -1) {
		var entries = get(name);
		if (entries != null) for (e in entries) if (mask == -1 || mask == e.mask ) e.onEvent();
	}

	/**
	 * Get events
	 * @param name
	 * @return Array<TEvent>
	 */
	public static function get(name:String):Array<TEvent> {
		return events.get(name);
	}

	/**
	 * Add event
	 * @param name Name of event
	 * @param onEvent Funtion to call when event it triggered
	 * @param mask = -1
	 * @return TEvent
	 */
	public static function add(name:String, onEvent:Void->Void, mask = -1):TEvent {
		var e:TEvent = { name: name, onEvent: onEvent, mask: mask };
		var entries = events.get(name);
		if (entries != null) entries.push(e);
		else events.set(name, [e]);
		return e;
	}

	/**
	 * Remove event
	 * @param name Name of event
	 */
	public static function remove(name:String) {
		events.remove(name);
	}

	/**
	 * Remove event listener
	 * @param event Event object
	 */
	public static function removeListener(event:TEvent) {
		var entries = events.get(event.name);
		if (entries != null) entries.remove(event);
	}
}

typedef TEvent = {
	var name:String;
	var onEvent:Void->Void;
	var mask:Int;
}
