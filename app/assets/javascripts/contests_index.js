var months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
    'Agustus', 'September', 'Oktober', 'November', 'Desember'];
var short_days = ['M', 'S', 'S', 'R', 'K', 'J', 'S'];
var long_days = ['Minggu', 'Senin', 'Selasa', 'Rabu',
    'Kamis', 'Jumat', 'Sabtu'];

$(document).ready(function() {

  if ($('body').attr('contests_page') != undefined) {

    var current_year = now.getFullYear();
    var current_month = now.getMonth();
    var current_date = now.getDate();
    var displayed_year = current_year;
    var displayed_month = current_month;

    var contests = $('#contest-data').data('contests');
    // Make start_time and end_time become Javascript Date objects
    for (var i = 0; i < contests.length; i++) {
      var contest = contests[i];
      contest.start_time = new Date(contest.start_time);
      contest.end_time = new Date(contest.end_time);
    }

    // Month is indexed from zero!
    function create_month_calendar(year, month) {
      function create_cell(date) {
        var cell_class = [];
        var txt = '<td';
        var class_text = '';
        var additions = '';
        var last = ('>' + date + '</td>');

        if (date !== '') {

          var date_obj = new Date(year, month, date);

          for (var i = 0; i < contests.length; i++) {
            var contest = contests[i];
            if (date_obj.compare_day(contest.start_time) >= 0 &&
                date_obj.compare_day(contest.end_time) <= 0) {
              cell_class.push("has-contest");
              additions += 'data-toggle="popover" data-container="body" ';
              additions += 'data-trigger="hover" data-placement="bottom"';
              additions += 'data-html="true"';
              additions += ('title="' + contest.name + '" ');

              var content = 'Dari ' + contest.start_time.format_indo() +
                ' sampai ' + contest.end_time.format_indo() + '<br>Format: ' +
                contest.number_of_short_questions + ' isian dan ' + 
                contest.number_of_long_questions + ' uraian';
              additions += ('data-content="' + content + '"');
              break;
            }
          }

          if (now.compare_day(date_obj) === 0) {
            cell_class.push("today");
          }
        }

        if (cell_class.length !== 0) {
          class_text += ' class="';
          for (var i = 0; i < cell_class.length; i++) {
            class_text += cell_class[i];
            if (i !== cell_class.length - 1) {
              class_text += ' ';
            }
          }
          class_text += '"';
        }
        return (txt + class_text + additions + last);
      }

      var first_day = new Date(year, month, 1).getDay();
      var last_date = new Date(year, month + 1, 0).getDate();
      var date = 1;
      var text = '<table class="table table-bordered ' +
        'table-condensed month-calendar has-shade">';

      text += '<thead><tr>';
      for (var i = 0; i < short_days.length; i++) {
        text += ('<th>' + short_days[i] + '</th>');
      }
      text += '</tr></thead><tbody><tr>';

      for (var i = 0; i < first_day; i++) {
        text += create_cell('');
      }
      for (var i = first_day; i < 7; i++) {
        text += create_cell(date);
        date++;
      }
      text += '</tr>';

      while (date <= last_date) {
        text += '<tr>';
        for (var i = 0; i < 7; i++) {
          if (date > last_date) {
            text += create_cell('');
          } else {
            text += create_cell(date);
            date++;
          }
        }
        text += '</tr>';
      }
      text += '</tbody></table>';
      return text;
    }

    function update_year_calendar(year) {

      $('#calendar').empty();
      $('#this-time').text(year);
      $('#prev-time').text('Tahun Sebelumnya');
      $('#next-time').text('Tahun Selanjutnya');

      for (var month = 0; month < months.length; month++) {
        if (month % 3 == 0) {
          $('#calendar').append('<div class="row"></div>');
        }

        var append_text = '<div class="col-md-4">';
        append_text += create_month_calendar(year, month);
        append_text += '</div>';
        $('#calendar .row:last-child').append(append_text);
        $("#calendar table.month-calendar").last().prepend('<caption>' +
            months[month] + '</caption>');
      }
    }

    function update_month_calendar(year, month) {
      $('#calendar').empty();
      $('#this-time').text(months[month] + ' ' + year);
      if (window_type() === "xs") {
        $('#prev-time').text('<<');
        $('#next-time').text('>>');
      } else {
        $('#prev-time').text('Bulan Sebelumnya');
        $('#next-time').text('Bulan Selanjutnya');
      }

      $('#calendar').append(create_month_calendar(year, month));
    }

    function window_type() {
      var width = $(window).width();
      return (width >= 992) ? "md" : (width >= 768) ? "sm" : "xs";
    }

    function update_calendar() {
      if (window_type() === "md") {
        update_year_calendar(displayed_year);
      } else {
        update_month_calendar(displayed_year, displayed_month);
      }
      $('[data-toggle="popover"]').popover();
      load_colors();
    }

    update_calendar();
    $(window).resize(update_calendar);

    $('#prev-time').click(function(e) {
      if (window_type() === "md") {
        displayed_year--;
      } else if (displayed_month === 0) {
        displayed_month += 11;
        displayed_year--;
      } else {
        displayed_month--;
      }
      update_calendar();
      e.preventDefault();
    });

    $('#next-time').click(function(e) {
      if (window_type() === "md") {
        displayed_year++;
      } else if (displayed_month === 11) {
        displayed_month -= 11;
        displayed_year++;
      } else {
        displayed_month++;
      }
      update_calendar();
      e.preventDefault();
    });
  }
});