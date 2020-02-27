require 'nokogiri'
require 'httparty'

desc "Retrieve Cedula Profesional information from SEP DB"
task :scraper => [ :environment ] do

    puts "Scrapping cedulas..."

    current_cedula = Cedula.count != 0 ? Cedula.last.cedula_number.to_i + 1 : 1

    max_cedulas = 11941338 #As of 2020/02/27

    null_count = 0

    while current_cedula <= max_cedulas
        cedula_number = set_number(current_cedula)
        url = "http://search.sep.gob.mx/solr/cedulasCore/select?fl=%2A%2Cscore&q=#{cedula_number}&start=0&rows=100&facet=true&indent=on&wt=json"
        unparsed_page = HTTParty.get(url, format: :plain)
        parsed_page = JSON.parse(unparsed_page)
        results = parsed_page["response"]["docs"]
        if(results.count > 0)
            results.each do |result|
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
            current_cedula += 1
            null_count = 0
        else
            if(null_count >= 5)
                abort 'Failed to proceed after 5 attempts '
            end
            null_count += 1
            sleep_time = (null_count * null_count)
            puts "HTTP Request returned nil. Waiting #{sleep_time} seconds to try again..."
            sleep(sleep_time)
        end
    end

    puts "Done!"
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
new_number = leading_zeros + number.to_s
return new_number
end
