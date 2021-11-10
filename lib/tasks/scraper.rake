# frozen_string_literal: true

require "nokogiri"
require "httparty"

desc "Retrieve Cedula Profesional information from SEP DB"
task scraper: [:environment] do
  puts "[ #{Time.zone.now} ] Scraper task started..."

  current_cedula = Cedula.count != 0 ? Cedula.last.cedula_number.to_i + 1 : 1

  puts "Current cedula = #{current_cedula}"

  max_cedulas = 11941338 # As of 2020/02/27

  null_count = 0

  while current_cedula <= max_cedulas
    cedula_number = build_number(current_cedula)
    url = "http://search.sep.gob.mx/solr/cedulasCore/select?fl=%2A%2Cscore&q=#{cedula_number}&start=0&rows=100&facet=true&indent=on&wt=json"
    begin
      unparsed_page = HTTParty.get(url, format: :plain)
      parsed_page = JSON.parse(unparsed_page)
      results = parsed_page["response"]["docs"]
      if results.count > 0
        results.each do |result|
          next if result["nombre"].number?
          next if result["nombre"].include?("--")
          next if result["paterno"].include?("--")
          next if result["materno"].include?("--")
          next if result["numCedula"] == cedula_number
          Cedula.create!(
            cedula_number: result["numCedula"],
            cedula_type: result["tipo"],
            name: result["nombre"],
            last_name_1: result["paterno"],
            last_name_2: result["materno"],
            gender: result["genero"],
            title: result["titulo"],
            institution: result["institucion"],
            year: result["anioRegistro"]
          )
        end
        if cedula_number.to_i % 1000 == 0 || null_count > 0
          puts "[ #{Time.zone.now} ] Cedula found. Resuming task on cedula #{cedula_number}..."
        end
        current_cedula += 1
        null_count = 0
      else
        null_count += 1
        if null_count == 1
          puts "-----------------------------------------------------------------------"
        end
        if null_count >= 1000
          finish = Time.zone.now.to_s
          abort("Failed to proceed after 1000 attempts at #{finish}")
        end
        if null_count.even?
          current_cedula += 1
        end
        puts "[ #{Time.zone.now} ] HTTP Request returned nil for cedula #{cedula_number} on attempt #{null_count}."
        puts "Waiting 1 second to try again..."
        sleep(1)
      end
    rescue Errno::ECONNREFUSED
      puts "[ #{Time.zone.now} ] Error: Connection Refused on cedula #{cedula_number}."
      puts "Waiting 60 seconds to try again..."
      null_count += 1
      sleep(60)
    rescue Errno::ECONNRESET
      puts "[ #{Time.zone.now} ] Error: Connection Reset on cedula #{cedula_number}."
      puts "Waiting 1 seconds to try again..."
      null_count += 1
      sleep(1)
    rescue Errno::EHOSTUNREACH
      puts "[ #{Time.zone.now} ] Error: Could not reach host on cedula #{cedula_number}."
      puts "Waiting 1 seconds to try again..."
      null_count += 1
      sleep(1)
    rescue Net::OpenTimeout
      puts "[ #{Time.zone.now} ] Error: Open Timeout on cedula #{cedula_number}."
      puts "Waiting 1 seconds to try again..."
      null_count += 1
      sleep(1)
    end
  end

  puts "[ #{Time.zone.now} ] Scraper task finished!"
end

def build_number(current_number)
  number = current_number.to_i
  leading_zeros = ""
  if number < 10
    leading_zeros += "0"
  end
  if number < 100
    leading_zeros += "0"
  end
  if number < 1000
    leading_zeros += "0"
  end
  if number < 10000
    leading_zeros += "0"
  end
  if number < 100000
    leading_zeros += "0"
  end
  if number < 1000000
    leading_zeros += "0"
  end
  if number >= 9050000
    leading_zeros += "0"
  end
  new_number = leading_zeros + number.to_s
  new_number
end

class String
  def number?
    true if Float(self)
  rescue
    false
  end
end
