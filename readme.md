# Financier

Financier is a comprehensive business management platform built on top of [Utopia](https://github.com/ioquatix/utopia) and [Relaxo](https://github.com/ioquatix/relaxo).

[![Development Status](https://github.com/oriontransfer/financier/workflows/Test/badge.svg)](https://github.com/oriontransfer/financier/actions?workflow=Test)

![Invoices](doc/Invoices.png)

## Installation

Copy the `example/` directory which contains the bare framework for running the application.

## Usage

First, create an admin user:

    bundle install
    bake financier:user:create

Then start the site:

    falcon serve

Visit <https://localhost:9292> to log in.
