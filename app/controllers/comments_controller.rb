class CommentsController < ApplicationController
    before_action :require_sign_in
    before_action :post_or_topic
    before_action :authorize_user, only: [:destroy]
    
    def create
      if @commentable == Post
        @post = Post.find(params[:post_id])
        comment = @post.comments.new(comment_params)
        comment.user = current_user
        
        if comment.save
            flash[:notice] = "Comment saved successfully."
            # #12
            redirect_to [@post.topic, @post]
            else
            flash[:alert] = "Comment failed to save."
            # #13
            redirect_to [@post.topic, @post]
        end
      else
        @topic = Topic.find(params[:topic_id])
        comment = @topic.comments.new(comment_params)
        comment.user = current_user
        
        if comment.save
            flash[:notice] = "Comment saved successfully."
            # #12
            redirect_to [@topic]
            else
            flash[:alert] = "Comment failed to save."
            # #13
            redirect_to [@topic]
        end
      end
    end
    
    def destroy
      if @commentable == Post
        @post = Post.find(params[:post_id])
        comment = @post.comments.find(params[:id])
        
        if comment.destroy
            flash[:notice] = "Comment was deleted successfully."
            redirect_to [@post.topic, @post]
            else
            flash[:alert] = "Comment couldn't be deleted. Try again."
            redirect_to [@post.topic, @post]
        end
      else
        @topic = Topic.find(params[:topic_id])
        comment = @topic.comments.find(params[:id])
      
        if comment.destroy
          flash[:notice] = "Comment was deleted successfully."
          redirect_to [@topic]
          else
          flash[:alert] = "Comment couldn't be deleted. Try again."
          redirect_to [@topic]
        end
      end
    end
    
    private
    
    # #14
    def comment_params
        params.require(:comment).permit(:body)
    end
    
    def authorize_user
        comment = Comment.find(params[:id])
        unless current_user == comment.user || current_user.admin?
            flash[:alert] = "You do not have permission to delete a comment."
            redirect_to [comment.post.topic, comment.post]
        end
    end
    
    def post_or_topic
        comment = Comment.find(params[:id])
        @commentable = Comment.find(params[:commentable])
    end

end
