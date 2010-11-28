
$(document).ready(function(){
                    $( "#rubygems" ).autocomplete({
                                                    source: '/gems',
                                                    select: function(event, ui){
                                                      window.location = '/gems/' + ui.item.value;
                                                    }
                                                  });
                    $( "#rubygems").focus();
                  });