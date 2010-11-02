class RecordsController < ApplicationController
  
  def index
    @records = Record.all
  end
  
  def new
  end
  
  def create
    Record.create(params[:key], params[:value])
    redirect_to records_path
  end
  
end
