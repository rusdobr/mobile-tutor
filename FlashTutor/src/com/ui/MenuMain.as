class com.ui.MenuMain extends com.ui.PanelBase 
{
	private var menu_holder_mc:MovieClip;
	private var _items:Array = [];
	private var _dictName:String = '';
	
	public function MenuMain() {
		super();
	}
	public function setMenuItems (arr:Array){
		_removeMenus();
		for (var i=0; i<arr.length; ++i) {
			_items.push(_createMenuItem (arr[i]));
		}
	}
	public function set dictName (name:String) {
		_dictName = name;
	}
	private function _createMenuItem(obj:Object){
		var id = _items.length+1;
		obj.width = 120;
		var menu_mc = menu_holder_mc.attachMovie('MenuItemMc', 'menu_'+id, id, obj);
		menu_mc._y = (id-1) * (menu_mc._height*1.5);
		return menu_mc;
	}
	private function _removeMenus() {
		while (_items.length) {
			_items.pop().removeMovieClip();
		}
	}
}