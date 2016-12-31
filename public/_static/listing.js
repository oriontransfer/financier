
jQuery(function($){
	$('table.listing').each(function() {
		var listing = $(this);
		
		listing.on("click", "a.button.delete", function() {
			var rows = $('tr:has(input.selected:checked)', listing), documents = [];
			rows.each(function() {
				documents.push($(this).data());
			});
			
			$.ajax({
				type: 'post',
				url: "delete",
				data: {documents: documents},
				success: function() {
					rows.remove();
				}
			});
		});
	});
});
