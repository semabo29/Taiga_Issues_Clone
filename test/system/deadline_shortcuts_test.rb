require "application_system_test_case"

class DeadlineShortcutsTest < ApplicationSystemTestCase
  setup do
    @deadline_shortcut = deadline_shortcuts(:one)
  end

  test "visiting the index" do
    visit deadline_shortcuts_url
    assert_selector "h1", text: "Deadline shortcuts"
  end

  test "should create deadline shortcut" do
    visit deadline_shortcuts_url
    click_on "New deadline shortcut"

    fill_in "Name", with: @deadline_shortcut.name
    fill_in "Offset days", with: @deadline_shortcut.offset_days
    click_on "Create Deadline shortcut"

    assert_text "Deadline shortcut was successfully created"
    click_on "Back"
  end

  test "should update Deadline shortcut" do
    visit deadline_shortcut_url(@deadline_shortcut)
    click_on "Edit this deadline shortcut", match: :first

    fill_in "Name", with: @deadline_shortcut.name
    fill_in "Offset days", with: @deadline_shortcut.offset_days
    click_on "Update Deadline shortcut"

    assert_text "Deadline shortcut was successfully updated"
    click_on "Back"
  end

  test "should destroy Deadline shortcut" do
    visit deadline_shortcut_url(@deadline_shortcut)
    click_on "Destroy this deadline shortcut", match: :first

    assert_text "Deadline shortcut was successfully destroyed"
  end
end
