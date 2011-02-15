App.Gems = {
  params: {
    bJQueryUI:   true,
    bServerSide: true,
    sAjaxSource: App.vars.paged_source
  },
  
  init_results_table: function() {
    $('.test-results-table').dataTable(this.params).fnSort([[1, 'desc']]);
  },
  
  init: function () {
    this.init_results_table();
  }
}