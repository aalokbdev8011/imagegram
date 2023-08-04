class CommentsController < ApplicationController
  before_action :find_post

  def create
    comment = @post.comments.new(comment_params)

    respond_to do |format|
      if comment.save
        format.html { redirect_to post_url(@post) }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content, :user_id)
  end
end
