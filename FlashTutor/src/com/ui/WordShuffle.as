class com.ui.WordShuffle extends com.ui.PanelBase 
{
	private var _words:Array;
	private var _currentWord : Array;
	private var _shuffledWord : String;
	private var _intval:Number = 0;
	private var translation_txt:TextField;
	private var sample_txt:TextField;
	private var shuffle_txt:TextField;
	private var width:Number;
	private var height:Number;
	private var _stat:Array = [];
	private var _totalWords:Number = 0;
	private var _totalShown:Number = 0;
	
	public function WordShuffle() {
		super();
	}
	
	public function setWords (words:Array) {
		_words = words.slice(0);
		_totalWords = _words.length;
		_totalShown = 0;
		_stat = [];
		_startWords();
	}
	private function _startWords () {
		_nextWord();
	}
	private function _nextWord () {
		clearInterval (_intval);
		if(_words.length == 0){
			_exit();
			return;
		}
		var rnd:Number = random(_words.length);
		_currentWord = _words[rnd];
		_stat[_currentWord.id] = _stat[_currentWord.id] == undefined ? 1 : _stat[_currentWord.id]+1;
		if (_stat[_currentWord.id] > 2){
			_words.splice(rnd);
		}
		_totalShown++;
		controller.setStatus(Math.round(_totalShown/(_totalWords*2)*100) + ' %');
		translation_txt.text = '' + _currentWord[1];
		sample_txt.text = '';
		shuffle_txt.text = _getShuffledWord (_currentWord[0]);
		_intval = setInterval (this, '_nextWord2', 3000);
	}
	private function _nextWord2 (){
		clearInterval (_intval);
		shuffle_txt.text = '';
		sample_txt.text = _currentWord[0];
		_intval = setInterval (this, '_nextWord', 2500);
	}
	private function _getShuffledWord (word:String):String {
		var word_out:String = '';
		while (word.length) {
			var rnd:Number = random (word.length);
			word_out += word.charAt(rnd);
			word = word.substr(0, rnd) + word.substr(rnd+1);
		}
		return word_out;
	}
	private function onMenuPress(btn:MovieClip) {
		switch(btn.id){
			case 'go-back':
				_exit();
			break;
		}
	}
	private function _exit() {
		this._parent.dispalyMainMenu();
	}
	private function _onResize () {
		this.width = Stage.width - 10;
		this.height = Stage.height - 5;
		this.translation_txt._width = this.width;
		this.sample_txt._width = this.width;
		this.shuffle_txt._width = this.width;
	}
	public function finalize(){
		clearInterval(_intval);
		super.finalize();
	}
}