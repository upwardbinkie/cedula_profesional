require 'nokogiri'
require 'httparty'

desc "Retrieve Cedula Profesional information from SEP DB"
task :scraper => [ :environment ] do

    puts "Scrapping cedulas... #{Time.zone.now.to_s}"

    start = Time.zone.now.to_s

    current_cedula = Cedula.count != 0 ? Cedula.last.cedula_number.to_i + 1 : 1

    max_cedulas = 11941338 #As of 2020/02/27

    null_count = 0

    while current_cedula <= max_cedulas
        cedula_number = set_number(current_cedula)
        url = "http://search.sep.gob.mx/solr/cedulasCore/select?fl=%2A%2Cscore&q=#{cedula_number}&start=0&rows=100&facet=true&indent=on&wt=json"
        begin
            unparsed_page = HTTParty.get(url, format: :plain)
            parsed_page = JSON.parse(unparsed_page)
            results = parsed_page["response"]["docs"]
            if(results.count > 0)
                results.each do |result|
                    if(!result["nombre"].is_number? && !result["nombre"].include?('-'))
                        cedula = Cedula.create!(
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
                end
                current_cedula += 1
                null_count = 0
            else
                null_count += 1
                if(null_count == 1)
                    puts "-----------------------------------------------------------------------"
                end
                if(null_count >= 1000)
                    finish = Time.zone.now.to_s
                    abort "Failed to proceed after 1000 attempts at #{finish}"
                end
                if(null_count % 2 == 0)
                    current_cedula += 1
                end
                puts "[ #{Time.zone.now.to_s} ] HTTP Request returned nil for cedula #{cedula_number} on attempt #{null_count}. Waiting 1 second to try again..."
                sleep(1)
            end
        rescue Errno::ECONNREFUSED
            puts "[ #{Time.zone.now.to_s} ] Connection Refused on cedula #{cedula_number}. Waiting 60 seconds to try again..."
            sleep(60)
        end
    end

    finish = Time.zone.now.to_s
    puts "Done! Started at #{start} and finished at #{finish}"
end

def set_number(current_number)
    number = current_number.to_i
    leading_zeros = ""
    if(number < 10)
        leading_zeros += "0"
    end
    if(number < 100)
        leading_zeros += "0"
    end
    if(number < 1000)
        leading_zeros += "0"
    end
    if(number < 10000)
        leading_zeros += "0"
    end
    if(number < 100000)
        leading_zeros += "0"
    end
    if(number < 1000000)
        leading_zeros += "0"
    end
    if(number >= 9050000)
        leading_zeros += "0";
    end
    new_number = leading_zeros + number.to_s
    return new_number
end

class String
  def is_number?
    true if Float(self) rescue false
  end
end
