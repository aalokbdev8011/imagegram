class PostsController < ApplicationController
  before_action :find_post, only: %i[show edit update destroy]

  def index
    @pagy, @posts = pagy(Post.includes(:user, :comments).order('comments_count ASC'), items: 1)
  end

  def show
    @comment = @post.comments.new
  end

  def new
    @post = current_user.posts.build
  end

  def edit
  end

  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        ImageConversionJob.perform_later(@post.id)

        format.html { redirect_to post_url(@post), notice: "Post successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        ImageConversionJob.perform_later(@post.id)

        format.html { redirect_to post_url(@post), notice: "Post successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to root_url, status: :see_other, notice: "Post destroyed." }
    end
  end

  private

  def find_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:caption, :image, :user_id)
  end
end
