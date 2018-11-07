class ConversationsController < ApplicationController
    def index
        # byebug
        @conversations = current_user.mailbox.conversations
    end

    def show
        @conversation = current_user.mailbox.conversations.find(params[:id])
    end

    def new
        # params variable 'r' is the recipient user id
        @recipient = User.find(params[:r])        
    end

    def create
        recipient = User.find(params[:recipient_id])
        receipt = current_user.send_message(recipient, params[:body], params[:subject])
        redirect_to conversation_path(receipt.conversation)
    end

    def destroy
        @conversation = current_user.mailbox.conversations.find(params[:id])
        @conversation.destroy
        respond_to do |format|
            format.html { redirect_to conversations_path, notice: 'Product was successfully destroyed.' }
            format.json { head :no_content }
        end
    end
end
