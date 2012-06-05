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