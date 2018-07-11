module ApplicationHelper
  # ページ固有のタイトル有無でタイトルの文字列を調整して返す。
  def full_title(page_title)
    base_title = "Simple SNS"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  # Bootstrapによるflashメッセージの装飾に必要な命令
  def bootstrap_class_for(flash_type)
    case flash_type
      when "success"
        "alert-success"
      when "error"
        "alert-danger"
      when "alert"
        "alert-warning"
      when "notice"
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def return_url(urlwords, viewwords)
    return "<a href=\"#{urlwords}\">#{viewwords}</a>"
  end

end
