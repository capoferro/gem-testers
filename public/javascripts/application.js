$(document).ready(init);

function init() {
  $('.version-select').change(function(event, ui){
                                window.location = event.target.value;
                              });
}