# Financier

Financier is a comprehensive business management platform built on top of [Utopia](https://github.com/ioquatix/utopia) and [Relaxo](https://github.com/ioquatix/relaxo).

[![Build Status](https://travis-ci.com/oriontransfer/financier.svg?branch=master)](https://travis-ci.com/oriontransfer/financier)

![Invoices](doc/Invoices.png)

## Installation

Copy the `example/` directory which contains the bare framework for running the application.

## Usage

First, create an admin user:

```
bundle install
bake financier:user:create
```

Then start the site:

```
falcon serve
```

Visit <https://localhost:9292> to log in.

## License

Copyright, 2017, by [Samuel G. D. Williams](http://www.codeotaku.com).

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
