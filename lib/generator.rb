require 'json'

class Generator
  Term = InvoiceConfig::TERM

  Data = {
    from: InvoiceConfig::FROM,
    to: "To Company",

    # logo: "https://invoiced.com/img/logo-invoice.png",

    payment_terms_title: "Week of",
    due_date_title: "Due Date",
    date_title: "Invoice Date",


    notes: "Thanks for your business! Any question, issue please email biz@getopty.com.",
    terms: Term,

    number: 1,
    items: [
      {name: "Starter plan", quantity: 1,unit_cost: 99}
    ],
  }

  def initialize(opts)
    @data = Data.dup
    @data.merge!(opts)

  end

  def generate!(file)
    File.write("data.json", @data.to_json)

    cmd = %(curl -sv https://invoice-generator.com \
        -H "Content-Type: application/json" \
        --data  @data.json \
        > #{file}.pdf)
    puts cmd
    %x(#{cmd})
    puts "Download to #{file}.pdf"
  end
end
