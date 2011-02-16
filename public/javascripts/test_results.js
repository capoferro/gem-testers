App.TestResults = {
  copy: null,

  init: function() {
    this.copy = $('#copy');
    this.load_events();
  },

  load_events: function() {
    this.copy.tipsy({ gravity: 's' });
    this.copy.mousedown(App.apply(this.copy_mousedown, this));
  },

  copy_mousedown: function() {
    this.copy
      .attr('title', 'copied!')
      .tipsy('hide')
      .tipsy('show')
      .attr('title', 'copy to clipboard');
  }
}