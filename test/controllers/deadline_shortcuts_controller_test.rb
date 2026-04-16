require "test_helper"

class DeadlineShortcutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @deadline_shortcut = deadline_shortcuts(:one)
  end

  test "should get index" do
    get deadline_shortcuts_url
    assert_response :success
  end

  test "should get new" do
    get new_deadline_shortcut_url
    assert_response :success
  end

  test "should create deadline_shortcut" do
    assert_difference("DeadlineShortcut.count") do
      post deadline_shortcuts_url, params: { deadline_shortcut: { name: @deadline_shortcut.name, offset_days: @deadline_shortcut.offset_days } }
    end

    assert_redirected_to deadline_shortcut_url(DeadlineShortcut.last)
  end

  test "should show deadline_shortcut" do
    get deadline_shortcut_url(@deadline_shortcut)
    assert_response :success
  end

  test "should get edit" do
    get edit_deadline_shortcut_url(@deadline_shortcut)
    assert_response :success
  end

  test "should update deadline_shortcut" do
    patch deadline_shortcut_url(@deadline_shortcut), params: { deadline_shortcut: { name: @deadline_shortcut.name, offset_days: @deadline_shortcut.offset_days } }
    assert_redirected_to deadline_shortcut_url(@deadline_shortcut)
  end

  test "should destroy deadline_shortcut" do
    assert_difference("DeadlineShortcut.count", -1) do
      delete deadline_shortcut_url(@deadline_shortcut)
    end

    assert_redirected_to deadline_shortcuts_url
  end
end
