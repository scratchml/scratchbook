class ScratchesController < ApplicationController

  before_filter :get_scratch, :only => [:show, :update, :destroy, :notation]
  skip_before_filter :verify_authenticity_token, :only => :create
  caches_action :show, :expires_in => 1.hour, :cache_path => lambda{ request_cache_key }

  def index
    @scratches = Scratch.order('created_at DESC').limit(50)
  end

  def show
    expire_action
    respond_to do |format|
      format.html { render }
      format.xml { render :xml => @scratch.data }
      format.json { render :json => @scratch.to_hash, :callback => params[:callback] }
    end
  end

  def notation
    render
  end

  def update
    raise 'TODO'
  end

  def create
    @scratch = Scratch.new

    if params[:data] && params[:data].kind_of?(String)
      @scratch.data = params[:data]
    elsif params[:data] && params[:data].kind_of?(ActionDispatch::Http::UploadedFile)
      @scratch.data = params[:data].read
    end
    @scratch.application = params[:application]
    @scratch.author = params[:author]

    respond_to do |format|
      if @scratch.save
        format.html { render :text => "OK", :layout => false }
        format.xml { render :xml => {:success => true, :id => @scratch.id } }
        format.json { render :json => {:success => true, :id => @scratch.id } }
      else
        errors = @scratch.errors.map{|k,v| v.blank? ? nil : "#{k} #{v}" }.compact
        logger.warn "errors => #{errors.inspect}"
        format.html { render :text => "Failed: #{errors.join(',')}", :layout => false, :status => 400 }
        format.xml { render :xml => {:success => false, :errors => errors}, :status => 400 }
        format.json { render :json => {:success => false, :errors => errors}, :status => 400 }
      end
    end
  end

  def destroy
    raise 'TODO'
  end

protected

  def get_scratch
    @scratch = Scratch.find(params[:id])
  end

  def request_cache_key(user=nil)
    "#{params[:controller]}/#{params[:action]}.#{params[:format] || 'html'}"
  end

end
