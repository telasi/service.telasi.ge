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
