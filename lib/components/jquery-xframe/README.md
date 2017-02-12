# jQuery.XFrame

jQuery.XFrame is a client-side include system built on top of AJAX. It is designed to simplify the development of cache friendly dynamic websites by simplifying the complexity of combining static content with dynamic content (or more generally, content with different caching strategies).

XFrame stands for eXternal Frame. It works a bit like an `<iframe>` tag, but its much easier to script.
	
jQuery.XFrame depends on jQuery 1.4.1+.

## Installation

The default minified distribution of jQuery.XFrame is available in public/.

To build a custom distribution, please copy install.yaml to site.yaml and update the appropriate configuration options. The use `rake install` to install jQuery.XFrame.

## Motivation

Building websites that are cache-friendly is difficult. Building websites that are both cache-friendly and dynamic is even more complex.

jQuery.XFrame allows HTML content with different caching strategies to be combined easily. It also imposes a light structure which to ensure best-practice when it comes to caching dynamically generated content.

As an example, consider a blog with comments. Comments can be generated in real time, but blog content is only generated once (or updated very infrequently).

We have a number of concerns:

* Blog content should be produced quickly for the end user.
* End user can add comments and see them immediately.
* Search engine can see blog content and possibly comments, but time frame does not need to be instantaneous.
* All content should be cached if possible.

In this case, we can use jQuery.XFrame to update comments dynamically. The first step is to take the existing page which includes blog content and comments, and wrap the comments using XFrame. The comments section should then be extracted to a partial view. The partial view should be made available via a standard web request.

The page should be rendered as per normal. Once the page is rendered, it can be cached for a long time, say 8 hours. When the page is served to the client, comments may be up to 8 hours old, so, new comments are missing. But, XFrame is triggered once the page has finished loading. This will request the partial from the web server. This content may have a cache time of 10 minutes, so comments are at most 10 minutes late, or even generated in real time. The content on the 8 hour old cache is updated with the new comments.

## License

Copyright, 2011, 2015, by Samuel G. D. Williams. <http://www.codeotaku.com>

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
