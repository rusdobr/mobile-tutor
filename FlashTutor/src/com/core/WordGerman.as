import com.core.Utils;

class com.core.WordGerman {
	private var _gender:String = '';
	private var _type:String = '';
	private var _pluralEnding:String = '';
	private var _word:String = '';
	private var _translation:String;
	
	function WordGerman(word:String, translation:String) {
		word = String(word);
		translation = String(translation);
		_parseType1Noun(word, translation);
	}
	
	private function _parseType1Noun (word:String, translation:String){
		_translation = translation;
		_gender = _getGender(word.substr(0,3));
		if (_gender != ''){
			_type = 'noun';
			var arr:Array = _extractBraces(word.substr(4), ['(', ')']);
			_word = arr[0];
			_pluralEnding = arr[1];
			return;
		}
		var arr:Array = _extractBraces(word.substr(4), ['(', ')']);
		_gender = _getGender(arr[1]);
		if (_gender != ''){
			_type = 'noun';
			_word = arr[0];
			return;
		}
		var arr:Array = _extractBraces(_translation.substr(4), ['[', ']']);
		_gender = _getGender(arr[1]);
		if (_gender != ''){
			_type = 'noun';
			_word = word;
			_translation = arr[0];
			var arr:Array = _extractBraces(_translation.substr(4), ['(', ')']);
			_translation = arr[0];
			_pluralEnding = arr[1];
			return;
		}
		if (word.indexOf('en') == word.length-1) {
			_type = 'verb';
		} else {
			_type = 'adverb';
		}
		_word = word;
	}
	private function _getGender(article:String) {
		switch(article) {
			case 'die':
			case 'f':
			return 'f';
			case 'der':
			case 'm':
			return 'm';
			case 'das':
			case 'n':
			return 'n';
		}
		return '';
	}
	
	private function _extractBraces(word:String, braces:Array){
		var val:String = '';
		var i1:Number = word.indexOf(braces[0]);
		if (i1 >= 0){
			var i2:Number = word.indexOf(braces[1]);
		}
		if (i1 >= 0 && i2 > 0 && i2 > i1 ){
			val = Utils.str_trim(word.substr(i1+1,i2-i1-1));
			word = Utils.str_trim(word.substr(0,i1))
				   Utils.str_trim(word.substr(i2));
		}
		return [word, val];
		
	}
	public function get word ():String {
		return _word;
	}
	public function get translation ():String {
		return _translation;
	}
	public function get pluralEnding():String {
		return _pluralEnding;
	}
	// returns f,m,n,p
	public function get gender():String {
		return _gender;
	}
	
	public function get isVerb():Boolean {
		return _type == 'verb';
	}
	
	public function get isNoun():Boolean {
		return _type == 'noun';
	}
	
}