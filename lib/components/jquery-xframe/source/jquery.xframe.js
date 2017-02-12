/* 
	This file is part of the "jQuery.XFrame" project, and is distributed under the MIT License.
	For more information, please see http://www.oriontransfer.co.nz/projects/jquery-xframe
	
	Copyright (c) 2011 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
*/

jQuery.xframe = function () {
	jQuery('.xframe').xreload();
};

jQuery.fn.xreload = function () {
	if (this.length == 0) return;
	
	var element = this, src = this.data('xframe-source');
	
	jQuery.ajax({
		url: src,
		cache: false,
		dataType: "html",
		success: function(data) {
			var fragment = jQuery(data);
			
			element.replaceWith(fragment);
			
			var interval = parseInt(fragment.data('xframe-interval'));
			
			console.log("Waiting for", interval * 1000, fragment);
			
			if (interval) {
				setTimeout(function() {
					fragment.xreload();
				}, interval * 1000);
			}
		}
	});
}

jQuery.fn.xframe = function () {
	$(this).closest('.xframe').xreload();
};
