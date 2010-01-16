// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function showNotifyBar(text, div_id, delay, speed){
  id = '#' + div_id;
  
  $j.notifyBar({
    html: text, 
    delay: delay, 
    animationSpeed: speed, 
    jqObject: $j(id)
  });
}