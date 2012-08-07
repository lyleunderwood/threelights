//= require jquery
//= require jquery_ujs
//= require_self
//= require_tree .

// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function() {
  jQuery('.detailImage').each(function(i, img) {
    img = jQuery(img);
    img.popupWindow({
      width: img.attr('data-width'),
      height: img.attr('data-height'),
      top: 0,
      left: Math.round((screen.width / 2) - img.attr('data-width') / 2),
      scrollbars: 1
    });
  });

  var list;
  if (list = $('#editCategories ul.albums').get(0)) {
    $(list).sortable({
      dropOnEmpty: false,
      cursor: 'crosshair',
      axis: 'y',
      items: 'li',
      opacity: 0.4,
      scroll: true,
      update: function(event, ui) {
        var id = ui.item.get(0).id;
        var items = $(list).sortable('toArray');

        var idx = items.indexOf(id);
        if (idx === -1) {
          return false;
        }

        var sent = true;

        $.ajax({
          url: id,
          type: 'put',
          data: {
            album: {
              position: idx,
            }
          },
          dataType: 'json',
          complete: function(request){
            console.log('got a complete', arguments);
          },
          error: function() {
            console.log('got an error', arguments);
          }
        }) // ajax
      } // update
    }); // sortable
  }
});
