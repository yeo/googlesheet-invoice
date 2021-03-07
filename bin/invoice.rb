require 'optparse'
require 'ostruct'

require_relative '../config'
require_relative '../lib/generator'
require_relative '../lib/sheet'

Options = Struct.new(:month, :sheet)

class Parser
  def self.parse(options)
    args = Options.new("world")

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: example.rb [options]"

      opts.on("-mMONTH", "--month=MONTH", "Month in sheet") do |n|
        args.month = n
      end

      opts.on("-sSHEET", "--sheet=SHEET", "Google Sheet ID") do |v|
        args.sheet = v
      end

      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end
options = Parser.parse ARGV

p options

include Sheet::Shortcuts
spreadsheet_id = options.sheet || InvoiceConfig::DEFAULT_SHEET_ID
range = "#{options.month}!A2:G"
response = sh.get_spreadsheet_values spreadsheet_id, range
puts "No data found." if response.values.empty?


def fetch_info(sh, spreadsheet_id)
  sh.get_spreadsheet_values(spreadsheet_id, 'info!a2:b')

 response = sh.get_spreadsheet_values spreadsheet_id, "info!A1:B"

 response.values.map do |row|
   [row[0], row[1]]
 end.to_h
end

info = fetch_info(sh, spreadsheet_id)

data = response.values.map do |row|
  # Print columns A and E, which correspond to indices 0 and 4.
  if row[0] && !row[0].empty?
    info[row[0]] = row[1]
    next
  end

  next if row[5].nil?

  {
    date: row[3],
    project: row[4],
    hour: row[5].to_f,
    title: row[4],
    description: (row[6] || "").strip,
  }
end.select { |v| v }

pp data

items = data.select { |v| v }.map { |row|
  {name: row[:title] + "\n" + row[:description], quantity: row[:hour].to_f, unit_cost: info['rate'].to_i}
}

g = Generator.new({
      to: "#{info["name"]}\n#{info['address']}",

      payment_terms: info["payment_terms"],
      due_date: info["due_date"],
      number: info["number"],
      header: info["header"],
      items: items,
    })

pp info

g.generate!("output/%s-%s-%s" % [info["name"].gsub(/[^0-9a-zA-Z_-]/, "").downcase, "2021", options.month.downcase])
