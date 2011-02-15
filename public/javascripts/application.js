App = {
  /**
   * Anything that needs to go from a Controll to Javascript
   * should be put into this object.
   *
   * Example:
   *    :javascript
   *      App.vars.paged_source = "#{@paged_source}";
   */
  vars: {},
  /**
   * Slices any Array-like object. Certain objects like +arguments+
   * don't have a native +slice+ method, so use this one in those
   * instances.
   */
  slice: function (list, start, length) {
    return Array.prototype.slice.call(list, start, length);
  },
  
  /**
   * Shortcut for applying scope to a method. When setting JQuery
   * event handlers use +apply+ to redifine +this+ to refer to the 
   * App.* object instead of the jQuery object.
   *
   * Example:
   *    App.Foo = { bar: function() { console.log(this) }}
   *=
   * without apply:
   *    $('whatever').click(App.Foo.bar) #=> <jQuery $('whatever')>
   *
   * with apply:
   *    $('whatever').click(apply(App.Foo.bar, App.Foo)) #=> <App.Foo>
   *
   *
   * Check out App.TestResults for an actual example of this.
   */
  apply: function (method, scope) {
    return function() { method.apply(scope, App.slice(arguments, 2)) }
  },
  
  /**
   * Get the party started!!!
   */
  init: function init() {
    for (module in App)
      if (typeof App[module].init == 'function')
        App[module].init();

    $('.version-select').change(function(event, ui){
      window.location = event.target.value;
    });
  }
}

$(document).ready(App.init);