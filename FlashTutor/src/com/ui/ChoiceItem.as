class com.ui.ChoiceItem extends MovieClip {
	private var label_txt:TextField;
	private var bg_mc:MovieClip;
	private var press_btn:Button;
	private var _pressHandler:Function;
	
	private var _w:Number;
	
	public function MenuItem() {
		super();
		onEnterFrame = function (){
			_initUI();
		}
	}
	private function _initUI() {
		if (this.width == undefined && label_txt.autoSize != 'left') {
			label_txt.autoSize = 'left';
			return;
		}
		delete onEnterFrame;
	}
	public function set width(w:Number) {
		this._w = w;
		label_txt._width = this._w - label_txt._x;
		bg_mc._width = this._w;
		press_btn._width = this._w;
	}
}