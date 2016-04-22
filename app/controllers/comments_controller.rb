class CommentsController < ApplicationController
    before_action :require_sign_in
    before_action :post_or_topic
    before_action :authorize_user, only: [:destroy]
    
    def create
        # #11
        if type == "Post"
            @post = Post.find(params[:post_id])
            comment = @post.comments.new(comment_params)
        else
            @topic = Topic.find(params[:topic_id])
            comment = @topic.comments.new(comment_params)
        end
        
        comment.user = current_user
        
        if comment.save
            flash[:notice] = "Comment saved successfully."
            # #12
            if type == "Post"
            redirect_to [@post.topic, @post]
            else
            redirect_to [@topic]
            end
        else
            flash[:alert] = "Comment failed to save."
            # #13
            if type == "Post"
                redirect_to [@post.topic, @post]
            else
                redirect_to [@topic]
            end
        end
    end
    
    def destroy
        @post = Post.find(params[:post_id])
        comment = @post.comments.find(params[:id])
        
        if comment.destroy
            flash[:notice] = "Comment was deleted successfully."
            if type == "Post"
                redirect_to [@post.topic, @post]
                else
                redirect_to [@topic]
            end
        else
            flash[:alert] = "Comment couldn't be deleted. Try again."
            if type == "Post"
                redirect_to [@post.topic, @post]
                else
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
        type = "Topic"
        if Comment.find(params[:commentable_id]) == Post
            type = "Post"
        end
    end
        
end
