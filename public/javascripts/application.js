// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(function() {
  $("#customers th a, #customers .pagination a").live("click", function() {
    $.getScript(this.href);
    return false;
  });
  $("#customers_search input").keyup(function() {
    $.get($("#customers_search").attr("action"), $("#customers_search").serialize(), null, "script");
    return false;
  });
});
