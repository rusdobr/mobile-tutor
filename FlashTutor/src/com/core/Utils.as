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
}