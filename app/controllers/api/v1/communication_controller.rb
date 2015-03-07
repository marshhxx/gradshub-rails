class Api::V1::CommunicationController < ApplicationController

  def create
    sender = User.find_by(uid: communication_params[:sender])
    receiver = User.find_by(uid: communication_params[:receiver])
    page_params = sender.onepgr_account.create_page
    if page_params.nil?
      @error = {:code => ONEPGR_ERROR, :reasons => sender.onepgr_account.onepgr_errors}
      render 'api/v1/common/error', status: :unprocessable_entity
    else
      if sender.onepgr_account.invite_user_to_page(receiver, page_params)
        render :json => {:communication => page_params}.to_json, :status => :created
      else
        @error = {:code => ONEPGR_ERROR, :reasons => sender.onepgr_account.onepgr_errors}
        render 'api/v1/common/error', status: :unprocessable_entity
      end
    end
  end

  private

  def communication_params
    params.require(:communication).permit(:sender, :receiver)
  end
end