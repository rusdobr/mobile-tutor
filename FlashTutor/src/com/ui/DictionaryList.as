import com.core.DictionaryItem;

class com.ui.DictionaryList extends com.ui.MenuMain 
{
	private var menu_holder_mc:MovieClip;
	private var _items:Array = [];
	
	public function DictionaryList() {
		super();
	}
	public function setDict (dict:Array){
		var mainMenuItems:Array = [];
		var me = this;
		var menuHandler = function (item:MovieClip) {
			me._onDictPress(item.item);
			me._exit();
		}
		for (var i = 0; i < dict.length; ++i ){
			var dictInfo:DictionaryItem = dict[i];
			var item = {
				label : dictInfo.label,
				item : dictInfo,
				_pressHandler : menuHandler
			};
			mainMenuItems.push(item);
		}
		setMenuItems (mainMenuItems);
	}
	private function onMenuPress(btn:MovieClip) {
		switch(btn.id){
			case 'go-back':
				_exit();
			break;
		}
	}
	private function _onDictPress (item:DictionaryItem){
		this._parent.loadDictionary(item);
	}
	private function _exit() {
		this._parent.dispalyMainMenu();
	}
}