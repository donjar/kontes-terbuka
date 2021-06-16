$(document).on('turbolinks:load', function() {
  function reset_descriptions() {
    $('.about-us-description').slideUp('fast');
    $('.active-about-us').removeClass('active-about-us');
  }
  $('.about-us-description').hide();

  $('.about-us-person').click(function() {
    var me = $(this);
    var deactivate = me.hasClass('active-about-us');
    reset_descriptions();
    if (!deactivate) {
      me.addClass('active-about-us');
      me.nextAll('.visible-' + window_type() + ':first')
        .nextAll('.about-us-description:first')
        .text(me.data('description')).slideDown('fast');
      ga('send', 'event', 'about-us', 'view', $(this).data('name'));
    }
  });
});
