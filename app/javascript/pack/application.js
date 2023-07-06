$(document).ready(function() {
    $('#filter-form input[type=checkbox]').change(function() {
      $('#filter-form').submit();
    });
  });