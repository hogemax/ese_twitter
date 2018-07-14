module UsersHelper

  # 該当ユーザーのメールアドレスに対応するGravatarの画像URLを返す
  def gravatar_for(user, options = { size: 50 })
    gravatar_id = Digest::SHA2::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    #rbh_size = "#{options[:size]}x#{options[:size]}"
    #gravatar_url = "https://robohash.org/#{gravatar_id}.jpg?size=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
