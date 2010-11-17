$(document).ready(init);

function init() {
  $('.version-select').change(function(event, ui){
                                window.location = event.target.value;
                              });
  // We currently can't detect the platform that native extensions are compiled on, so we're not using this code.
  // $('.result-cell').each(function() {
  //                          $(this).mouseover(trigger_platform_overlay);
  //                          $(this).mouseout(destroy_platform_overlay);
  //                        });
}

function trigger_platform_overlay() {
  var self = $(this);
  var os = self.attr('operating_system');
  var ruby = self.attr('ruby_version');
  $.get('/rubygems/' + rubygem_id + '/platform_overlay', {operating_system: os, ruby_version: ruby}, function(data) {
          $('#platform-data').html(data);
        });
}

function destroy_platform_overlay() {
  $('.platform-overlay').remove();
}