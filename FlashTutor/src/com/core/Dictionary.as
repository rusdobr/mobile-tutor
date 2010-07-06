import mx.events.EventDispatcher;
import com.core.Utils;
import com.core.WordGerman;

class com.core.Dictionary extends EventDispatcher {
	private var _words:Array = [];
	public function Dictionary() {
		super();
	}
	
	public function load (url:String) {
		var me = this;
		var loader:LoadVars = new LoadVars();
		loader.onData = function (data:String){
			if (data == undefined){
				me._onLoadError (url);
			} else {
				me._onDataLoaded(data);
			}
		}
		loader.load (url);
	}
	private function _onLoadError (url:String) {
		dispatchEvent ({type : 'DictionaryLoadError', target : this, url : url});
	}
	private function _onDataLoaded (data:String) {
		_parse(data);
		dispatchEvent ({type : 'DictionaryReady', target : this});
	}
	private function _parse(data:String) {
		_words = [];
		var rows = data.split ('\n');
		for (var i=0; i<rows.length; ++i) {
			var row = Utils.str_trim(rows[i]);
			row = Utils.str_trim(row, '\r');
			if (row.length > 0){
				var pair:Array = row.split(': ');
				pair.id = i;
				var word:WordGerman = new WordGerman(pair[0], pair[1]);
				//trace(pair[0]+':'+word.gender+':'+word.word+':'+word.pluralEnding+':'+word.isNoun);
				_words.push (pair);
			}
		}
	}
	public function get words ():Array {
		return _words;
	}
	public function get length ():Number {
		return _words.length;
	}
}