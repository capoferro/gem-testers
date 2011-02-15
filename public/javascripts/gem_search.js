App.GemSearch = {
  search_box: null,
  
  init_autocomplete: function () {
    this.search_box.autocomplete({
      source: '/gems',
      select: this.visit_gem_page
    });
  },
  
  visit_gem_page: function (event, ui) {
    window.location = '/gems/' + ui.item.value;
  },
  
  init: function () {
    this.search_box = $("#rubygems");
  }
}

$(document).ready(function(){
  $("#rubygems").autocomplete({
    source: '/gems',
    select: function(event, ui) {
      window.location = '/gems/' + ui.item.value;
    }
  });
  
  $( "#rubygems").focus();
});