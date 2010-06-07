import mx.events.EventDispatcher;
import com.core.DictionaryItem;

class com.core.Config extends EventDispatcher {
	private var _dict:Array = [];
	function Config(){
		super();
	}
	public function load (url:String) {
		var me = this;
		var loader:XML = new XML();
		loader.ignoreWhite = true;
		loader.onLoad = function (success:Boolean){
			if (!success || loader.status != 0){
				me._onLoadError (url);
			} else {
				me._onDataLoaded(loader);
			}
		}
		loader.load (url);
	}
	private function _onLoadError (url:String) {
		dispatchEvent ({type : 'ConfigLoadError', target : this, url : url});
	}
	private function _onDataLoaded (xml:XML) {
		_parse(xml);
		dispatchEvent ({type : 'ConfigReady', target : this});
	}
	private function _parse(xml:XML) {
		var rootNode:XMLNode = xml.firstChild;
		if (rootNode.nodeName != 'config'){
			if (rootNode.firstChild.nodeName != 'config') {
				return;
			} else {
				rootNode = rootNode.firstChild;
			}
		}
		for( var c=0; c<rootNode.childNodes.length; ++c){
			var node:XMLNode = rootNode.childNodes[c];
			if (node.nodeName == 'dict') {
				_parseDict(node);
				
			}
		}
	}
	private function _parseDict(parentNode:XMLNode) {
		_dict = [];
		for( var c=0; c<parentNode.childNodes.length; ++c){
			var node:XMLNode = parentNode.childNodes[c];
			if (node.nodeName == 'item') {
				_dict.push(new DictionaryItem(node.attributes));
			}
		}
	}
	public function get dict ():Array {
		return _dict;
	}
	public function get length ():Number {
		return _dict.length;
	}
	
}