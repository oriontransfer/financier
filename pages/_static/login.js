
jQuery(function($){
	$('form.login').each(function(){
		element = $(this);
		
		element.submit(function(){
			$.ajax({
				url: "/login/salt",
				type: 'GET',
				data: {name: $('input[name=name]', element).val()},
				async: false,
				cache: false,
				success: function(salts) {
					var salts = salts.split(',');
					
					var password = $('input[name=password]').val();
					var password_digest = $.sha1(password + salts[0]);
					var login_digest = $.sha1(password_digest + salts[1]);
					
					$('input[name=password]', element).val("");
					$('input[name=login_digest]', element).val(login_digest);
				}
			});
		});
	});
});