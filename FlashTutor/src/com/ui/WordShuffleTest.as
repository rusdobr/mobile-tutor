class com.ui.WordShuffleTest extends com.ui.PanelBase 
{
	private var _words:Array;
	private var _currentWord : Array;
	private var _currentWordId:Number = -1;
	private var _currentErrNumber:Number = 0;
	private var _shuffledWord : String;
	private var translation_txt:TextField;
	private var shuffle_txt:TextField;
	private var _letters :Array = [];
	private var _samples :Array = [];
	private var letters_mc : MovieClip;
	private var samples_mc : MovieClip;
	private var _currentLetterIndex: Number = -1;
	private var width:Number;
	private var height:Number;
	private var _stat:Array = [];
	private var _totalWords:Number = 0;
	
	public function WordShuffleTest() {
		super();
	}
	
	public function setWords (words:Array) {
		_words = words.slice(0);
		_totalWords = _words.length;
		_stat = [];
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
		_currentWord = _words[_currentWordId];
		_currentErrNumber = 0;
		translation_txt.text = '' + _currentWord[1];
		_shuffledWord = _getShuffledWord (_currentWord[0]);
		_removeLetters();
		_createLetters();
		_removeSamples();
		_createSamples();
		_currentLetterIndex = -1;
		_selectCurrentLetter();
	}
	private function _displayResults() {
		_exit();
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
	private function _createLetters() {
		for (var i=0; i<_currentWord[0].length; ++i ){
			var obj = {
				letter : _currentWord[0].charAt(i),
				_visible : false,
				visible : true
			}
			var letter_mc:MovieClip = letters_mc.attachMovie ("LetterMC", "letter_" + i, i+1, obj);
			if (letter_mc.letter == '_' || letter_mc.letter == ' ' ){
				letter_mc.visible = false;
				letter_mc._width = Math.round(letter_mc._width/2);
			}
			letter_mc.onEnterFrame = function (){
				delete this.onEnterFrame;
				this.letter_txt._visible = false;
				this._visible = this.visible;
			}
			_letters.push(letter_mc);
		}
		_orientLetters(_letters);
	}
	
	private function _orientLetters(letters:Array) {
		var letter_x:Number = 0;
		var letter_y:Number = 0;
		var parent_mc:MovieClip = null;
		for (var i=0; i < letters.length; ++i ){
			var letter_mc:MovieClip = letters[i];
			parent_mc = letter_mc._parent;
			if (letter_x + letter_mc._width + 2> this.width){
				letter_x = 0;
				letter_y += letter_mc._height + 2;
			}
			letter_mc._x = letter_x;
			letter_mc._y = letter_y;
			letter_x += letter_mc._width + 2;
		}
		if (parent_mc != null) {
			parent_mc._x = 5 + Math.round ((this.width-parent_mc._width)/2);
		}
	}
	private function _removeLetters() {
		while (_letters.length) {
			var letter_mc = _letters.pop();
			letter_mc.removeMovieClip();
		}
	}
	private function _createSamples () {
		var me = this;
		for (var i=0; i<_shuffledWord.length; ++i ){
			var obj = {
				letter : _shuffledWord.charAt(i)
			}
			if (obj.letter == '_' || letter_mc.letter == ' ' ){
				continue;
			}
			var letter_mc:MovieClip = samples_mc.attachMovie ("LetterButtonMC", "letter_" + i, i+1, obj);
			letter_mc.press_btn.onPress = function () {
				me.__onSampleButtonPress(this);
			}
			_samples.push(letter_mc);
		}
		_orientLetters(_samples);
	}
	private function _removeSamples() {
		while (_samples.length) {
			var letter_mc = _samples.pop();
			letter_mc.removeMovieClip();
		}
	}
	private function _removeSampleButton(letter_mc:MovieClip) {
		for (var i=0; i<_samples.length; ++i){
			if (_samples[i] == letter_mc ){
				_samples.splice(i, 1);
				letter_mc.removeMovieClip();
				_orientLetters(_samples);
				break;
			}
		}
	}
	private function __onSampleButtonPress(press_btn:Button) {
		var letter:String = press_btn._parent.letter;
		if (letter == _currentWord[0].charAt(_currentLetterIndex)) {
			this._removeSampleButton(press_btn._parent);
			this._selectCurrentLetter();
		} else {
			_currentErrNumber++;
			_level0.beep();
		}
	}
	private function _selectCurrentLetter (){
		if (_currentLetterIndex >= 0){
			_letters[_currentLetterIndex].letter_txt._visible = true;
		}
		if (_samples.length == 1 ){
			this._displayWord();
			return;
		}
		var letter_mc:MovieClip;
		do {
			_currentLetterIndex++;
			letter_mc = _letters[_currentLetterIndex];
			if (letter_mc == undefined){
				this._displayWord();
				return;
			}
		} while (letter_mc.letter == ' ' || letter_mc.letter == '_');
		letter_mc.hilight_mc._alpha = 100;
	}
	private function _displayWord(timeout:Number) {
		timeout = timeout == undefined ? 500 : timeout;
		_removeSamples();
		for( var i=0; i < _letters.length; ++i) {
			_letters[i].letter_txt._visible = true;
			_letters[i].hilight_mc._alpha = 100;
		}
		if (timeout > 0){
			var me = this;
			var timer = setInterval(function (){;clearInterval(timer);me._nextWord()}, timeout);
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
		this.translation_txt._width = this.width;
		this._orientLetters(_letters);
		this._orientLetters(_samples);
	}
	public function finalize(){
		_removeLetters();
		_removeSamples();
		super.finalize();
	}
}