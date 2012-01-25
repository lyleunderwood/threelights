// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function() {
  jQuery('.detailImage').each(function(i, img) {
    img = jQuery(img);
    img.popupWindow({
      width: img.attr('data-width'),
      height: img.attr('data-height'),
      top: 0,
      left: Math.round((screen.width / 2) - img.attr('data-width') / 2)
    });
  });
});