$(document).on("turbolinks:load", function(){
  $fileField = $('#post_preview')
 
  $($fileField).on('change', $fileField, function(e) {
    file = e.target.files[0]
    reader = new FileReader(),
    $preview = $("#img_field");
    
    if(file === undefined){
      $preview.empty();
      return false;
    }
 
    reader.onload = (function(file) {
      return function(e) {
        $preview.empty();
        $preview.append($('<img>').attr({
          src: e.target.result,
          width: "100%",
          class: "post_preview",
          title: file.name
        }));
      };
    })(file);
    reader.readAsDataURL(file);
  });
});


$(document).on("turbolinks:load", function(){
  $fileField = $('#icon_preview')
 
  $($fileField).on('change', $fileField, function(e) {
    file = e.target.files[0]
    reader = new FileReader(),
    $preview = $("#img_field");
    $default = $("#default_field");
    
     if(file === undefined){
      $preview.empty();
      $default.show();
      return false;
    }
 
    reader.onload = (function(file) {
      return function(e) {
        $default.hide();
        $preview.empty();
        $preview.append($('<img>').attr({
          src: e.target.result,
          width: "200",
          class: "icon_preview",
          title: file.name
        }));
      };
    })(file);
    reader.readAsDataURL(file);
  });
});