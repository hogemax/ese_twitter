class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user,   only: :destroy
  #before_action :set_micropost, only: [:edit, :update, :destroy] # 「:show」を削除

  def index
    @microposts = Micropost.all
    @micropost = Micropost.new
    @hashtags = Hashtag.all

    #redirect_to controller: 'microposts', action: 'show'
  end

  def show
    if params[:id] == "show_all"
      show_tag_view
    else
      #hashTag = Hashtag.find_by(id: params[:id])
      hashTag = Hashtag.find_by(name: params[:id])
      if hashTag == nil || hashTag.microposts.empty?         # 「:id」でハッシュタグを検索
        session[:hashtag] = nil                              # 存在しなければindexへリダイレクト
        redirect_to root_path, method: 'get'
        return
      else
        session[:hashtag] = params[:id]                      # ハッシュタグが存在すれば

        # そのハッシュタグのツイートを全て取得
        #@microposts = Micropost.joins(:hashtags).where(hashtags: { id: params[:id] }).paginate(page: params[:page])
        @microposts = Micropost.joins(:hashtags).where(hashtags: { name: params[:id] }).paginate(page: params[:page])

        show_tag_view
      end
    end
  end

  def show_tag_view
     @micropost = Micropost.new
     @hashtags = Hashtag.all
     @hashtags = Hashtag.all.paginate(page: params[:page]) if params[:id] == "show_all"
     #render :index
     render :show
  end

  def create
    @micropost = current_user.microposts.build(micropost_params)
    str = @micropost.content
    hashTagNames = ""
    hashTagName = nil
    pathHashTag = nil

    str.to_s.gsub!(/#/, "\n#")
    str.to_s.gsub!(/(\s|　)+/, "\n")
#logger.debug "ハッシュタグとスペース 毎に改行"
#logger.debug "#{str}__;"

    str.each_line(rs="\n") {|line|
      hashTagNames << line if line.match(/#\S*/)
    }
#logger.debug "各ハッシュタグ（のData）を表示"
#logger.debug "#{hashTagNames};"

    if hashTagNames.present?
      exitTag = nil

      hashTagNames.each_line {|line|
        hashTagName = line.to_s.gsub(/(\s|　)+|\R/, '')
        pathHashTag = hashTagName.sub(/\A#/, "")

        @micropost.content = @micropost.content.sub(/^(?!>)#{hashTagName}/, %Q{<a data-method="get" href="/microposts/#{pathHashTag}">#{hashTagName}</a>}) #ハッシュタグ文字をリンク化

        hashTagName = hashTagName.sub(/\A#/, "") #先頭の#を削除

        exitTag = Hashtag.find_by(name: hashTagName) # 既に存在しているハッシュタグか確認
        if exitTag == nil
          hashTag = Hashtag.new                      # 存在しなければハッシュタグを新規作成
          hashTag.name = hashTagName
          @micropost.hashtags << hashTag             # ハッシュタグと投稿の関連付け
          hashTag.save!
        else
          @micropost.hashtags << exitTag             # ハッシュタグと投稿の関連付け
        end
      }
      session[:hashtag] = pathHashTag if pathHashTag #ハッシュタグがあればセッションに保存
      #session[:hashtag] = exitTag if session[:hashtag]
    else
      session[:hashtag] = nil #ハッシュタグが文中に無ければセッション情報を消す
    end

    @micropost.save ? flash[:success] = "Micropost created!" : @microposts = []
#logger.debug "DB保存時エラーがあれば表示"
#logger.debug @micropost.errors.inspect

    if !session[:hashtag]
      redirect_to root_url, method: 'get'
    else
      # そのハッシュタグのツイートのみ表示
      redirect_to micropost_path(session[:hashtag]), method: 'get'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
