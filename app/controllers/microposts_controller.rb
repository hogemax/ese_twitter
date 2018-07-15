class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user,   only: :destroy

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
      hashTag = Hashtag.find_by(name: params[:id])
      if hashTag == nil || hashTag.microposts.empty?         # 「:id」でハッシュタグを検索
        session[:hashtag] = nil                              # 存在しなければindexへリダイレクト
        redirect_to root_path, method: 'get'
        return
      else
        session[:hashtag] = params[:id]                      # ハッシュタグが存在すれば

        # そのハッシュタグのツイートを全て取得
        #@microposts = Micropost.joins(:hashtags).where(hashtags: { name: params[:id] }).includes(:user).paginate(page: params[:page])
        @microposts = Micropost.includes(:hashtags, :user).references(:hashtags).where(hashtags: { name: params[:id] }).paginate(page: params[:page])

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

    #投稿内容をハッシュタグごとに段落分けして各ハッシュタグを変数に格納
    str.to_s.gsub!(/#/, "\n#")
    str.to_s.gsub!(/(\s|　)+/, "\n")
    str.each_line(rs="\n") {|line|
      hashTagNames << line if line.match(/#\S*/)
    }

    if hashTagNames.present?
      exitTag = nil

      hashTagNames.each_line {|line|
        sharpHashTagName = line.to_s.gsub(/(\s|　)+|\R/, '')  #空白を改行に置換え
        hashTagName = sharpHashTagName.sub(/\A#/, "")         #先頭の#を削除

       # ハッシュタグリンクは表示するときにリンクに置き換える方式にする

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

    #repostであれば引用元の投稿情報を紐づける
    if params[:post_source].present?
      citation = Citation.new
      citation.source_id = params[:post_source][:id]  #引用元の投稿IDを取得
      citation.repost_id = Micropost.last.id + 1      #最新のIDを取得して設定
      @micropost.citations << citation
      citation.save!
     # @micropost.content << %Q{<br /><div class="panel panel-default">#{repost_source_build}</div>}
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
    end

  end

  def destroy
    #遷移元の情報を取得
    ref_path = Rails.application.routes.recognize_path(request.referrer)

    #削除処理
    @micropost = Micropost.search_by_id(params[:id])
    @micropost.destroy

    #遷移先の判定
    if ref_path[:controller] == 'users' && ref_path[:id].present?
      redirect_to controller: 'users', action: 'show', id: ref_path[:id] and return
    elsif ref_path[:controller] == 'microposts' && ref_path[:id].present?
      redirect_to controller: 'microposts', action: 'show', id: ref_path[:id] and return
    end
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
