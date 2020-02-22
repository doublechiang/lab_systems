var main = function () {
    $('#sse_result').hide();
    
    var $username = <%= @system.username %>;
    var $password = <%= @system.password %>;
    var $ip = <%= @system.ipaddr %>;
    if (!($username && $password && $ip)) {
      $('#sse_result').hide();
      return false;
    }
}

$(document).ready(main);
