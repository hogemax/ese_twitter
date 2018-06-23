$(document).on('turbolinks:load', function() { //$(function(){
  //新規投稿ボタン（POST）
  var newPostButton = $('div.container form.new_micropost').find('input[name="commit"]');

  //新規投稿入力欄に文字列が入力されていればPOSTボタンの表示
  $('aside.col-md-4 textarea#micropost_content').on('input click keypress blur', function(){
    ($(this).val() === "") ? postButtonDecoRemove( newPostButton ): postButtonDecoAdd( newPostButton );
  });

  //モーダル開いたとき（新規投稿の内容が入力してあれば一旦空にする）
  //$('div#repostModal').on('show.bs.modal', function (event) {
  //    postButtonDecoRemove( newPostButton ); //newPostButton.removeClass( "btnAttractAttentionOne gradientStyleOne" );
  //});
});

//---- Global Function ----//

function postButtonDecoRemove( targetButton ) {
  targetButton.removeClass( "btnAttractAttentionOne gradientStyleOne" );
}
function postButtonDecoAdd( targetButton ) {
  targetButton.addClass( "btnAttractAttentionOne gradientStyleOne" );
}
