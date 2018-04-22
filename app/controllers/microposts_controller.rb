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
    sharpHashTagName = nil
    hashTagName = nil

    str.to_s.gsub!(/#/, "\n#")
    str.to_s.gsub!(/(\s|　)+/, "\n")
#logger.debug "ハッシュタグとスペース 毎に改行" #logger.debug "#{str}__;"

    str.each_line(rs="\n") {|line|
      hashTagNames << line if line.match(/#\S*/)
    }
#logger.debug "各ハッシュタグ（のData）を表示" #logger.debug "#{hashTagNames};"

    if hashTagNames.present?
      exitTag = nil

      hashTagNames.each_line {|line|
        sharpHashTagName = line.to_s.gsub(/(\s|　)+|\R/, '')
        hashTagName = sharpHashTagName.sub(/\A#/, "") #先頭の#を削除

        @micropost.content = @micropost.content.sub(/^(?!>)#{sharpHashTagName}/, %Q{<a data-method="get" href="/microposts/#{hashTagName}">#{sharpHashTagName}</a>}) #ハッシュタグ文字をリンク化

        exitTag = Hashtag.find_by(name: hashTagName)  # 既に存在しているハッシュタグか確認
        if exitTag == nil
          hashTag = Hashtag.new                       # 存在しなければハッシュタグを新規作成
          hashTag.name = hashTagName
          @micropost.hashtags << hashTag              # ハッシュタグと投稿の関連付け
          hashTag.save!
        else
          @micropost.hashtags << exitTag              # ハッシュタグと投稿の関連付け
        end
      }
      session[:hashtag] = hashTagName if hashTagName  #ハッシュタグがあればセッションに保存
      #session[:hashtag] = exitTag if session[:hashtag]
    else
      session[:hashtag] = nil #ハッシュタグが文中に無ければセッション情報を消す
    end

    #repostであれば元の投稿を後ろに追記
    if repost_source_build.present?
      @micropost.content << %Q{<br /><div class="panel panel-default">#{repost_source_build}</div>}      #logger.debug @micropost.content
    end


    if @micropost.save #投稿成功時
      flash[:success] = "Micropost created!"
      #リダイレクト先を判定して移動
      destination = !session[:hashtag] ? root_url : micropost_path(session[:hashtag])
      redirect_to destination, method: 'get'

    else #投稿失敗時（バリデーションエラー等）
      @feed_items = []
      @microposts = []
      @hashtags = Hashtag.all
      render session[:hashtag] ? "microposts/#{session[:hashtag]}" : 'static_pages/home'
    end #logger.debug "DB保存時エラーがあれば表示" #logger.debug @micropost.errors.inspect

  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  def repost_source_build
    sourceContent = nil
    if params[:post_source]
      #repost用のデータ取得
      postSourceId = params[:post_source][:id]
      originalPost = Micropost.find_by(id: postSourceId)
      originalUser = User.find_by(id: originalPost.user_id)
      originalImage = nil

      #画像がある場合の処理
      if originalPost.image.present?
        originalImage = %Q{<div><img src="#{originalPost.image}" alt=""></div>}
      end

      originalPost.content << %Q{<br /><a href="/users/#{originalPost.user_id}">#{originalImage}@#{originalUser.name}</a>}     # logger.debug originalPost.content

      sourceContent = originalPost.content
    end

    return sourceContent
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
