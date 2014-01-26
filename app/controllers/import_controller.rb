class ImportController < ApplicationController
  def upload
    if @user.file.exists?
      redirect_to import_processing_path
    end
  end
  
  def processing
    if !@user.file.exists? && !params[:user][:file]
      redirect_to import_path
    else
      if params[:user] && params[:user][:file]
        @user.file = params[:user][:file]
        @user.save
      end
    end
  end
end