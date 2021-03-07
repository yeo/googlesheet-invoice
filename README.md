# Invoice

A simple app that fetch invoice data in a google sheet and render an PDF
file.

# Sponsor

Invoice is develop at [hanami.run](https://hanami.run), an email forwarding service for your
own domain. Give it a try if you have domain and want to receive and
send email through your own domain

# How to use this

## Prepare

Follow this doc https://developers.google.com/docs/api/quickstart/ruby
to enable google docs api and download credentials.json to this
directory. **never commit this file to git**

## 1. Prepare sheet

For each of your client Make a copy of this https://docs.google.com/spreadsheets/d/1h-daK2IewlNLxQmI_nLNW1qH_dNyUKTr1oPbnByykmw/edit#gid=1913647590 Take note of the id (the part betweeb `/d/[id-here]/edit`

For each month, create a new sheet sheet and name it January, February,
March etc

## 2. Edit config

Rename sample_config.rb to config.rb with your data

## 3. Generate  invoice

Run this:

```
ruby bin/invoice.rb -mFebruary -s[google-sheet-id]-above
```

Replace `-m` with sheet name whatever you name it

The first time you run it will asked you to login to google, approve
your own auth which you create in Prepare steps.

A PDF file will be store in your `output/` in the format of
`companyname-year-month.pdf`

## Script argument

- *-s*: google sheet id. useful when you have more than one client and
  maintain multiple google sheet
- *-m*: the month name of each sheet in your google document

# How it works

It leverage https://invoice-generator.com/ service to generate PDF. Data
is store in google sheet. You manually input your hour, rate etc into
the google sheet. One google sheet per customer.

The scripts fetch data in your google sheet, use your OAuth credential,
generate a JSON file and feed this JSON file to invoice-generator.com
