# frozen_string_literal: true

class Cedula < ApplicationRecord
  validates :cedula_number, uniqueness: { scope: :cedula_type, message: "Cedula number %{value} already exists" }
end
