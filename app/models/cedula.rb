class Cedula < ApplicationRecord
    validates :cedula_number, uniqueness: { scope: :cedula_type, message: "Cedula number already exists" }
end
