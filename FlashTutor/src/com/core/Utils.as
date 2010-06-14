class com.core.Utils {
	public static function str_trim (txt_str:String) {
		while (txt_str.charAt(0) == ' ') {
			txt_str = txt_str.substring(1, txt_str.length);
		}
		while (txt_str.charAt(txt_str.length-1) == ' ') {
			txt_str = txt_str.substring(0, txt_str.length-1);
		}
		return txt_str;
	}
	public static function getShuffledWord(word:String) : String {
		var word_out:String = '';
		while (word.length) {
			var rnd:Number = random (word.length);
			word_out += word.charAt(rnd);
			word = word.substr(0, rnd) + word.substr(rnd+1);
		}
		return word_out;
	}
}