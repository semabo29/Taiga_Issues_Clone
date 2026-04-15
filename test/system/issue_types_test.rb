require "application_system_test_case"

class IssueTypesTest < ApplicationSystemTestCase
  setup do
    @issue_type = issue_types(:one)
  end

  test "visiting the index" do
    visit issue_types_url
    assert_selector "h1", text: "Issue types"
  end

  test "should create issue type" do
    visit issue_types_url
    click_on "New issue type"

    fill_in "Color", with: @issue_type.color
    fill_in "Name", with: @issue_type.name
    click_on "Create Issue type"

    assert_text "Issue type was successfully created"
    click_on "Back"
  end

  test "should update Issue type" do
    visit issue_type_url(@issue_type)
    click_on "Edit this issue type", match: :first

    fill_in "Color", with: @issue_type.color
    fill_in "Name", with: @issue_type.name
    click_on "Update Issue type"

    assert_text "Issue type was successfully updated"
    click_on "Back"
  end

  test "should destroy Issue type" do
    visit issue_type_url(@issue_type)
    click_on "Destroy this issue type", match: :first

    assert_text "Issue type was successfully destroyed"
  end
end
