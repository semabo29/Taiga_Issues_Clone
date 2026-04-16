class WatchingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issue

  def create
    if params.key?(:user_id)
      # Si le dio al "+" pero no seleccionó a nadie
      if params[:user_id].blank?
        redirect_to @issue # Redirigimos sin hacer nada
        return
      else
        user_to_add = User.find(params[:user_id])
      end
    else
      # Si viene del botón directo de "WATCH", usamos al usuario actual
      user_to_add = current_user
    end
    
    @issue.watchers << user_to_add unless @issue.watchers.include?(user_to_add)
    redirect_to @issue, notice: "Watcher added."
  end

  def destroy
    user_to_remove = params[:user_id].present? ? User.find(params[:user_id]) : current_user
    
    @issue.watchers.delete(user_to_remove)
    redirect_to @issue, notice: "Watcher removed."
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end
end