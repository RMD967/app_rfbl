class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @discover = Discover.find(params[:discover_id])
    @comment = @discover.comments.new(comment_params)
    @comment.user = current_user
    authorize @comment

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to discovers_path }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("comment_error_#{@discover.id}",
            html: "<div id='comment_error_#{@discover.id}' class='text-danger small mt-1'>#{@comment.errors.full_messages.join(', ')}</div>"
          )
        end
        format.html { redirect_to discovers_path, alert: @comment.errors.full_messages.join(', ') }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    authorize @comment
    @discover = @comment.discover
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to discovers_path }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :parent_id)
  end
end
