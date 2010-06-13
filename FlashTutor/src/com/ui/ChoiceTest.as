import com.core.WordGerman;

class com.ui.ChoiceTest extends com.ui.PanelBase 
{
	private var _words:Array;
	private var _wordsOrig:Array;
	private var _currentWord : WordGerman;
	private var _currentWordId:Number = -1;
	private var _currentErrNumber:Number = 0;
	private var _currentType:String; // word | trans
	private var sample_txt:TextField;
	private var _samples :Array = [];
	private var samples_mc : MovieClip;
	private var width:Number;
	private var height:Number;
	private var _stat:Array = [];
	private var _totalWords:Number = 0;
	private var _correctId:Number = -1;
	private var _timer:Number = 0;
	private static var N_SAMPLES = 5;
	
	public function WordShuffleTest() {
		super();
	}
	
	public function setWords (words:Array) {
		_words = words.slice(0);
		_wordsOrig = _words.slice(0);
		_totalWords = _words.length;
		_stat = [];
		sample_txt.autoSize = 'left';
		_startWords();
	}
	private function _startWords () {
		_currentWordId = -1;
		_currentErrNumber = 0;
		_nextWord();
	}
	private function _nextWord () {
		if (_currentWordId != -1 && _currentErrNumber == 0){
			_words.splice(_currentWordId, 1);
		}
		controller.setStatus(Math.round(100-_words.length/_totalWords*100) + ' %');
		if (_words.length == 0){
			_displayResults();
			return;
		}
		_currentWordId = random(_words.length);
		_currentWord = new WordGerman(_words[_currentWordId][0],_words[_currentWordId][1]) ;
		_currentErrNumber = 0;
		_currentType = random(2) ? 'trans' : 'word';
		var text:String;
		if ( _currentType == 'trans' ){
			text = _currentWord.translation;
		} else {
			text = _getOriginalText(_currentWord);
		}
		sample_txt.text = text;
		_createSamples();
		_orientSamples();
		Selection.setFocus(_samples[0]);
	}
	private function _displayResults() {
		_exit();
	}
	private function _getOriginalText(word:WordGerman):String{
		var text:String = word.word;
		if (word.gender !=  '') {
			text += ' ['  + word.gender + ']';
		};
		if (word.pluralEnding !=  '') {
			text += ' ('  + word.pluralEnding + ')';
		};
		return text;
	}
	private function _createSamples() {
		_removeSamples();
		var word_mc:MovieClip = _createSampleButton(_currentWord);
		_samples.push(word_mc);
		while (_samples.length < N_SAMPLES ){
			var wordId:Number = random(_wordsOrig.length);
			var word:WordGerman = new WordGerman(_wordsOrig[wordId][0],_wordsOrig[wordId][1]) ;
			if (word.word == _currentWord.word){
				continue;
			}
			var word_mc:MovieClip = _createSampleButton(word);
			_samples.push(word_mc);
		}
		_correctId = random(N_SAMPLES);
		var tmp = _samples[0];
		_samples[0] = _samples[_correctId];
		_samples[_correctId] = tmp;
		for( var i:Number=0; i < _samples.length; ++i){
			_samples[i].sample_id = i;
		}
	}
	private function _createSampleButton(word:WordGerman) : MovieClip{
		var text:String;
		if ( _currentType != 'trans' ){
			text = word.translation;
		} else {
			text = _getOriginalText(word);
		}
		var i:Number = _samples.length + 1;
		var obj : Object = {
			label : text,
			_visible : false
		}
		var letter_mc:MovieClip = samples_mc.attachMovie ("ChoiceItemMc", "word_" + i, i+1, obj);
		var me = this;
		letter_mc.press_btn.onPress = function () {
			me.__onSampleButtonPress(this);
		}
		return letter_mc;
	}
	private function _removeSamples() {
		while (_samples.length) {
			var letter_mc = _samples.pop();
			letter_mc.removeMovieClip();
		}
	}
	private function _orientSamples(){
		var orientSamples2 = function (){
			for(var i:Number=0; i < this._samples.length; ++i){
				this._samples[i]._y = 5 + (this._samples[i]._height+3) * i;
				this._samples[i]._visible = true;
				this._samples[i].width = this.width;
			}
			delete this.onEnterFrame;
			this.samples_mc._visible = true;
		}
		onEnterFrame = function (){
			this.samples_mc._y = this.sample_txt._y + sample_txt._height;
			onEnterFrame = orientSamples2;
		}
	}
	private function __onSampleButtonPress(press_btn:Button) {
		var sample_id:Number = press_btn._parent.sample_id;
		if (sample_id == _correctId) {
			this._displayWord();
		} else {
			_currentErrNumber++;
			_level0.beep();
		}
	}
	private function _displayWord(timeout:Number) {
		timeout = timeout == undefined ? 500 : timeout;
		if (timeout > 0){
			var me = this;
			_timer = setInterval(
				function (){
					clearInterval(me._timer);
					me._removeSamples();
					me._nextWord()
				},
				timeout
			);
		}
	}
	private function onMenuPress(btn:MovieClip) {
		switch(btn.id){
			case 'go-back':
				_exit();
			break;
			case 'go-next':
				_currentErrNumber = -1;
				_nextWord();
			break;
			case 'show-word':
				_currentErrNumber = -1;
				_displayWord(0);
			break;
		}
	}
	private function _exit() {
		this._parent.dispalyMainMenu();
	}
	private function _onResize () {
		this.width = Stage.width - 10;
		this.height = Stage.height - 5;
		this.sample_txt._width = this.width;
		this._orientSamples();
	}
	public function finalize(){
		_removeSamples();
		clearInterval(_timer);
		super.finalize();
	}
}