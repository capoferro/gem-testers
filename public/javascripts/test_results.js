App.TestResults = {
  initialized: false,

  // Div around the "select all" textarea
  textbox: null,
  
  // Textarea containing test output
  textarea: null,
  
  // Div around regular text test output
  output: null,
  
  // Select All/Revert button
  selectall: null,
  
  // Height of output
  _height: null,
  
  // Width of output
  _width: null,

  /**
   * These selectors won't be available until the page is
   * fully loaded, so call this function at that point. 
   * See App#init and App.TestResults#init.
   */
  load_selectors: function load_selectors() {
    this.textbox   = $('#textbox');
    this.textarea  = this.textbox.find('textarea');
    this.output    = $('#output');
    this.selectall = $('#select-all');
    this._height   = this.output.height();
    this._width    = this.output.width();
  },

  show_text: function show_text() {
    this.textbox.height(this._height);
    this.textbox.width(this._width - 6);
    this.textbox.show();

    this.textarea.select();
    this.output.hide();

    this.selectall.html('Revert');
    this.selectall.unbind('click');
    this.selectall.bind('click', App.apply(this.hide_text, this));
  },

  hide_text: function hide_text() {
    this.output.show();
    this.textbox.hide();

    this.selectall.html('Select All');
    this.selectall.unbind('click');
    this.selectall.bind('click', App.apply(this.show_text, this));
  },

  init: function init() {
    this.load_selectors();
    this.selectall.unbind('click');
    this.selectall.bind('click', App.apply(this.show_text, this));
  }
}