class CommentsController < ApplicationController
    before_action :require_sign_in
    before_action :authorize_user, only: [:destroy]
    
    def create
        
        comment = Comment.new(comment_params)
        comment.user = current_user
        
        if params[:post_id]
            @parent = Post.find(params[:post_id])
            
        else
            @parent = Topic.find(params[:topic_id])
        end

        
        if comment.save
            @parent.comments << comment
            flash[:notice] = "Comment saved successfully."
            
        else
            flash[:alert] = "Comment failed to save."
        end
        
        if params[:post_id]
            redirect_to [@parent.topic, @parent]
        else
            redirect_to [@parent]
        end
    end
    
    def destroy
        
        
        if params[:post_id]
            @parent = Post.find(params[:post_id])
        else
            @parent = Topic.find(params[:topic_id])
        end
        
        comment = @parent.comments.find(params[:id])
        
        if comment.destroy
            flash[:notice] = "Comment was deleted successfully."
        else
            flash[:alert] = "Comment couldn't be deleted. Try again."
        end
        
        if params[:post_id]
            redirect_to [@parent.topic, @parent]
        else
            redirect_to [@parent]
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
            if params[:post_id]
                redirect_to [Post.find(params[:post_id]).topic, Post.find(params[:post_id])]
            else
                redirect_to Topic.find(params[:topic_id])
            end
        end
    end
    
        
end
