class com.ui.MenuItem extends MovieClip {
	private var label_txt:TextField;
	private var bg_mc:MovieClip;
	private var menu_btn:Button;
	private var _pressHandler:Function;
	
	public var width:Number;
	public var height:Number;
	
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
		if(this.width == undefined){
			this.width = label_txt._width + label_txt._x*2;
		} else {
			label_txt._width = this.width - label_txt._x*2;
		}
		menu_btn._width = this.width;
		bg_mc._width = this.width;
		var me = this;
		menu_btn.onRelease = function (){
			if (me._pressHandler != undefined) {
				me._pressHandler(me);
			}
		}
	}
}