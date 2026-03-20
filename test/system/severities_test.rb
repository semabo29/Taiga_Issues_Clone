require "application_system_test_case"

class SeveritiesTest < ApplicationSystemTestCase
  setup do
    @severity = severities(:one)
  end

  test "visiting the index" do
    visit severities_url
    assert_selector "h1", text: "Severities"
  end

  test "should create severity" do
    visit severities_url
    click_on "New severity"

    fill_in "Color", with: @severity.color
    fill_in "Name", with: @severity.name
    click_on "Create Severity"

    assert_text "Severity was successfully created"
    click_on "Back"
  end

  test "should update Severity" do
    visit severity_url(@severity)
    click_on "Edit this severity", match: :first

    fill_in "Color", with: @severity.color
    fill_in "Name", with: @severity.name
    click_on "Update Severity"

    assert_text "Severity was successfully updated"
    click_on "Back"
  end

  test "should destroy Severity" do
    visit severity_url(@severity)
    click_on "Destroy this severity", match: :first

    assert_text "Severity was successfully destroyed"
  end
end
