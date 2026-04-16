class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_issue, only: [:create]
  before_action :set_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @issue.comments.build(comment_params)
    @comment.user = current_user 

    if @comment.save
      redirect_to @issue, notice: "Comentario añadido."
    else
      redirect_to @issue, alert: "No se pudo añadir el comentario."
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      redirect_to @comment.issue, notice: "Comentario actualizado."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    issue = @comment.issue
    @comment.destroy
    redirect_to issue, notice: "Comentario borrado."
  end

  private

  def set_issue
    @issue = Issue.find(params[:issue_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end