var Telasi = {
  getTariffs2012: function(callback) {
	var url = '/app/tariffs.json';
	$.get(url, callback, 'json');
  }
};