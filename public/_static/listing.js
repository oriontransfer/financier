
jQuery(function($){
	$(document).on('click', 'table.listing a.button.delete', function() {
		var $listing = $(this).closest('.listing');
		
		var elements = $listing.find('tr:has(input.selected:checked)'), rows = [];
		elements.each(function() {
			rows.push($(this).data());
		});
		
		var href = "delete";
		
		if (this.getAttribute('href') != '#') {
			href = this.href;
		}
		
		$.ajax({
			type: 'post',
			url: href,
			data: {rows: rows},
			success: function() {
				elements.add(elements.next('.related')).fadeOut(300, function(){$(this).remove()});
			}
		});
		
		return false;
	});
});
