class com.ui.PanelBase extends MovieClip {
	public var controller:Object;
	
	public function PanelBase () {
		controller = _parent;
		Stage.addListener (this);
		onResize();
	}
	private function onResize() {
		_onResize();
	}
	private function _onResize() {
	}
	public function finalize(){
		Stage.removeListener(this);
	}
}