var Telasi = new Object();

Telasi.setFormWaitingOnSubmit = function(formId) {
  $('#' + formId).submit(function() {
    var submitButton = $('#' + formId + ' input[type=submit]');
    if (submitButton) {
      submitButton.val('დაელოდეთ...');
      submitButton.attr('disabled', 'disabled');
    } else {
      console.log('submit button not found');
    }
      return true;
  });
};

Telasi.datepickerInitialization = function() {
  $('.datepicker').datepicker({
    dateFormat: 'dd-M-yy',
    monthNames: ['იანვარი', 'თებერვალი', 'მარტი', 'აპრილი', 'მაისი', 'ივინისი', 'ივლისი', 'აგვისტო', 'სექტემბერი', 'ოქტომბერი', 'ნოემბერი', 'დეკემბერი'],
    dayNamesMin: ['კვ', 'ორ', 'სმ', 'ოთ', 'ხთ', 'პრ', 'შბ'],
    changeMonth: true,
    changeYear: true
  });
};

Telasi.simpleSearchSetup = function(options, callback) {
  var field  = $('#' + (options.field  || 'search-field' )); // ძებნის ველი
  var result = $('#' + (options.result || 'search-result')); // ადგილი შედეგისთვის
  field.keyup(function() {
    var query    = field.val();
    if (Telasi.curr_q && query === Telasi.curr_q) return;
    Telasi.curr_q = query;
  	var url      = options.url;
    var full_url =  url + '?q=' + query;
  	$.get(full_url, function(data) {
  	  data = JSON.parse(data);
  	  if ((Telasi.curr_q ? '' : Telasi.curr_q) === (data.q ? '' : data.q)) {
        result.html(data.d);
        if (callback) callback();
      }
    }, 'html');
  });
  Telasi.curr_q = field.val();
};