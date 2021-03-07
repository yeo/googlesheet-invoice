module InvoiceConfig
  # This is the part between id/[id-here]/edit in your google sheet URL
  # https://docs.google.com/spreadsheets/d/id-here/edit#gid=459600029
  DEFAULT_SHEET_ID = ""

  FROM = "hanami.run\nCompany address\nCity\nphone#"

  TERM = <<-TERM
Payment methods:

  1. Make check payable to:
     https://hanami.run
     Street
     Address

  2. Direct Deposit
     Account number: xxx
     Routing number: xxx
  TERM
end
