
$(document).ready(function(){
                    $( "#rubygems" ).autocomplete({
                                                    source: '/rubygems',
                                                    select: function(event, ui){
                                                      window.location = '/rubygems/' + ui.item.value;
                                                    }
                                                  });
                    $( "#rubygems").focus();
                  });