# frozen_string_literal: true

json.extract!(cedula, :id, :cedula_number, :cedula_type, :name, :last_name_1, :last_name_2, :gender, :title,
  :institution, :year, :created_at, :updated_at)
json.url(cedula_url(cedula, format: :json))
