$( document ).ready(function() {
  function getRowInputs($row) {
    return $row.find('input:not([type=hidden]), textarea').not('.hidden');
  }

  function getRowSelects($row) {
    return $row.find('select');
  }

  function clearRow($row) {
    var inputs = getRowInputs($row);
    var selects = getRowSelects($row);
    inputs.val('');
    // trigger autosize JQuery plugin to adapt to new content
    inputs.trigger('autosize.resize');
    selects.prop('selectedIndex', 0);
  }

  $('.clear').click(function(){
    var tr = $(this).closest('tr');
    clearRow(tr);
  });

  $('.duplicate').click(function(){
    var current_tr = $(this).closest('tr');
    var current_inputs = getRowInputs(current_tr);
    var current_selects = getRowSelects(current_tr);
    // .next() returns a hidden input (of the nested form)
    var next_tr = current_tr.nextAll('tr').first();
    var next_inputs = getRowInputs(next_tr);
    var next_selects = getRowSelects(next_tr);

    current_inputs.each(function(i) {
      var input = next_inputs.eq(i);
      input.val($(this).val());
      // trigger autosize JQuery plugin to adapt to new content
      input.trigger('autosize.resize');
    });
    current_selects.each(function(i) {
      // var current_option = $(this).find('option:selected').index();
      var current_opt = $(this).prop('selectedIndex');
      next_selects.eq(i).prop('selectedIndex', current_opt);
    });
  });

  /* https://gist.github.com/krcourville/7309218 */
  $('table.arrow-nav').keydown(function(e){
      var $active = $('input[type=text]:focus', $(this));
      var $next = null;
      var focusableQuery = 'input[type=text]:visible';
      var position = parseInt( $active.closest('td').index() ) + 1;
      switch(e.keyCode){
          case 38: // <Up>
              $next = $active
                  .closest('tr')
                  .prev()
                  .find('td:nth-child(' + position + ')')
                  .find(focusableQuery);
              break;
          case 40: // <Down>
              $next = $active
                  .closest('tr')
                  .next()
                  .find('td:nth-child(' + position + ')')
                  .find(focusableQuery);
              break;
      }
      if ($next && $next.length) { $next.focus(); }
  });

});