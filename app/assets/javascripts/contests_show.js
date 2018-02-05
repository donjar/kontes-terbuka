/* exported fill_contest_text */
function fill_contest_text() {
	var current = new Date();

	var current_contest = $('#contest-data');
	if ($('#contest-data').length !== 0) {
		$('#contest-name').text(current_contest.data('name'));

		var current_start_time = erb_to_date(
				current_contest.data('start-time'));
		var current_end_time = erb_to_date(
				current_contest.data('end-time'));
		var current_result_time = erb_to_date(
				current_contest.data('result-time'));
		var current_feedback_time = erb_to_date(
				current_contest.data('feedback-time'));

		var subtitle = '';
		var time_remaining = '';

		var FIVE_MINUTES = 300;

		if (current < current_start_time) {
			// Contest has not started
			subtitle = 'Kontes dimulai ' + current_start_time.format_indo() +
				'. Mohon bersabar!';
			time_remaining = '(' + current.indo_go_to(current_start_time) + ')';
		} else if (current < current_end_time) {
			// Contest has not ended
			$('.row > section').addClass('col-sm-8');

			if (Math.round((current_end_time - current) / 1000) == FIVE_MINUTES) {
				alert('Waktu tersisa 5 menit lagi. Bersiap-siaplah untuk ' +
					'mengumpulkan jawaban.');
			}

			subtitle = 'Batas pengumpulan: ' + current_end_time.format_indo();
			time_remaining = '(' + current.indo_go_to(current_end_time) + ')';
		} else if (current_contest.data('result-released')) {
			$('.row > section').removeClass('col-sm-8');

			if (current < current_feedback_time) {
				subtitle = 'Hasil kontes sudah keluar! Jangan lupa, Anda ' +
					'bisa memberikan feedback ke kami paling lambat ' +
					current_feedback_time.format_indo() + '!';
				time_remaining = '(' + current.indo_go_to(current_feedback_time)
					+ ')';
			} else {
				subtitle = current_contest.data('book-promo');
				time_remaining = '';
			}
		} else if (current < current_result_time) {
			// Results has not been released
			$('.row > section').removeClass('col-sm-8');

			if (Math.round((current - current_end_time) / 1000) == 1) {
				window.location.reload();
			}

			subtitle = 'Kontes sudah selesai. Hasil kontes akan keluar ' +
				'paling lambat ' + current_result_time.format_indo() +
				'. Mohon bersabar!';
			time_remaining = '(' + current.indo_go_to(current_result_time) +
				')';
		} else {
			// Results should be released manually.
			subtitle = 'Dikarenakan berbagai halangan, hasil kontes belum ' +
				'keluar. Mohon maaf atas ketidaknyamannya dan mohon ' +
				'bersabar :(';
			time_remaining = '';
		}

		$('#subtitle').html(subtitle);
		$('#time-remaining').html(time_remaining);
	}
}

$(document).on('turbolinks:load', function() {
	var show_contest_about = false;
	var show_all_problems = false;
	var show_own_results = false;

	$('#contest-about').hide();
	$('#all-problems').hide();
	$('#own-results').hide();

	$('#show-contest-about').click(function() {
		if (show_contest_about) {
			$('#contest-about').slideUp('slow', function() {
				$('#show-contest-about').text('Tampilkan');
				show_contest_about = false;
			});
		} else {
			$('#contest-about').slideDown('slow', function() {
				$('#show-contest-about').text('Sembunyikan');
				show_contest_about = true;
			});
		}
	});

	$('#show-all-problems').click(function() {
		if (show_all_problems) {
			$('#all-problems').slideUp('slow', function() {
				$('#show-all-problems').text('Tampilkan');
				show_all_problems = false;
			});
		} else {
			$('#all-problems').slideDown('slow', function() {
				$('#show-all-problems').text('Sembunyikan');
				show_all_problems = true;
			});
		}
	});

	$('#show-own-results').click(function() {
		if (show_own_results) {
			$('#own-results').slideUp('slow', function() {
				$('#show-own-results').text('Tampilkan');
				show_own_results = false;
			});
		} else {
			$('#own-results').slideDown('slow', function() {
				$('#show-own-results').text('Sembunyikan');
				show_own_results = true;
			});
		}
	});
});
