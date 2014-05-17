$(function() {
  var search_string = '';
  var $friends_ui_blocks = $('.friend-block-container:not(.add-friend)');
  var friends_data = Array.prototype.slice.call($friends_ui_blocks.map(function () { $this = $(this); return { name: $this.find('.friend-block-friend-name').text().trim().toLowerCase(), email: $this.find('.friend-block-friend-email').text().trim().toLowerCase().replace('@', '').replace(/\./g, ''), $dom: $this } }));
  var show = function (el) { $(el).show().parent().css('min-height', 1); }
  var hide = function (el) { $(el).hide().parent().css('min-height', 0); }
  var check_for_match = function (friend, search_string) { return friend.name.indexOf(search_string) != -1 || friend.email.indexOf(search_string) != -1 }
  var filter_friends_by = function (search_string) { if (search_string.length === 0) return friends_data.map(function (i) { return i.$dom; }); return friends_data.filter(function (friend) { return check_for_match(friend, search_string); }).map(function (i) { return i.$dom; }); }
  var all_friends = function () { return $friends_ui_blocks.toArray(); }
  var visible_friends = function () { return $($friends_ui_blocks.selector + ":visible"); }
  var toggle_button_text = function (friends) { if (friends.length == 0) $('#btnSearch').show(); else $('#btnSearch').hide(); }
  var toggle_add_friend = function (friends) { if (friends.length == 0) $('.add-friend').show(); else $('.add-friend').hide(); }

  $('#email').bind('keyup', function () {
    search_string = $(this).val().trim().toLowerCase().replace(/\./g,'').replace('@','');
    all_friends().forEach(hide);
    filter_friends_by(search_string).forEach(show);
    toggle_add_friend(visible_friends());
    toggle_button_text(visible_friends());
  });
});