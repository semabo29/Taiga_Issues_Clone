class WatchingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issue

  def create
    @issue.watchers << current_user unless @issue.watchers.include?(current_user)
    redirect_to @issue, notice: "Watching issue."
  end

  def destroy
    @issue.watchers.delete(current_user)
    redirect_to @issue, notice: "Stopped watching issue."
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end
end