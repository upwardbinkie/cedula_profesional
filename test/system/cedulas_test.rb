# frozen_string_literal: true

require "application_system_test_case"

class CedulasTest < ApplicationSystemTestCase
  setup do
    @cedula = cedulas(:one)
  end

  test "visiting the index" do
    visit cedulas_url
    assert_selector "h1", text: "Cedulas"
  end

  test "creating a Cedula" do
    visit cedulas_url
    click_on "New Cedula"

    fill_in "Cedula number", with: @cedula.cedula_number
    fill_in "Cedula type", with: @cedula.cedula_type
    check "Gender" if @cedula.gender
    fill_in "Institution", with: @cedula.institution
    fill_in "Last name 1", with: @cedula.last_name_1
    fill_in "Last name 2", with: @cedula.last_name_2
    fill_in "Name", with: @cedula.name
    fill_in "Title", with: @cedula.title
    fill_in "Year", with: @cedula.year
    click_on "Create Cedula"

    assert_text "Cedula was successfully created"
    click_on "Back"
  end

  test "updating a Cedula" do
    visit cedulas_url
    click_on "Edit", match: :first

    fill_in "Cedula number", with: @cedula.cedula_number
    fill_in "Cedula type", with: @cedula.cedula_type
    check "Gender" if @cedula.gender
    fill_in "Institution", with: @cedula.institution
    fill_in "Last name 1", with: @cedula.last_name_1
    fill_in "Last name 2", with: @cedula.last_name_2
    fill_in "Name", with: @cedula.name
    fill_in "Title", with: @cedula.title
    fill_in "Year", with: @cedula.year
    click_on "Update Cedula"

    assert_text "Cedula was successfully updated"
    click_on "Back"
  end

  test "destroying a Cedula" do
    visit cedulas_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cedula was successfully destroyed"
  end
end
