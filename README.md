# Financier

Financier is a comprehensive business management platform built on top of [Utopia](https://github.com/ioquatix/utopia) and [Relaxo](https://github.com/ioquatix/relaxo).

![Invoices](doc/Invoices.png)

## Installation

Install the ruby gem as follows:

	git clone https://github.com/ioquatix/financier.git
	cd financier
	bundle install

## Usage

To create a user:

	$ rake financier:users:create
	Login name: admin
	Login password: ••••••

Then, to start the development server:

	$ rake
	* Version 3.8.2 (ruby 2.4.0-p0), codename: Sassy Salamander
	* Min threads: 0, max threads: 16
	* Environment: development
	* Listening on tcp://0.0.0.0:9292
	* Starting control server on tcp://0.0.0.0:9293

You can now open <http://localhost:9292> in your browser and log in.

## License

Copyright, 2017, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

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
