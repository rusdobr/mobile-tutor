// Id::
class com.core.DictionaryItem {
	private var _data:Object;
	function DictionaryItem(data:Object) {
		_data = data;
	}
	public function get label ():String {
		return _data.label;
	}
	public function get varsion ():String {
		return _data.ver;
	}
	public function get url():String {
		return _data.url;
	}
}