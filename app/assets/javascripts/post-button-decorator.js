$(document).on('turbolinks:load', function() {
//$(function(){
  $('aside.col-md-4 textarea#micropost_content').on('input click keypress blur', function(){
  //$('textarea#micropost_content').on('input click keypress blur', function(){
    var contents = $(this).val();
    var postButton = $('form.new_micropost').find('input[name="commit"]');

    if(contents === "") {
      //console.log("空");
      postButton.removeClass( "btnAttractAttentionOne gradientStyleOne" );
      //postButton.val("post")
    } else {
      //console.log("入力値あり");
      postButton.addClass( "btnAttractAttentionOne gradientStyleOne" );
      //postButton.val("post")
    }
  });

  //モーダル開いたとき
  $('div#repostModal').on('show.bs.modal', function (event) {
      //新規投稿の内容が入力してあれば一旦空にする
      $('form.new_micropost').find('input[name="commit"]').removeClass( "btnAttractAttentionOne gradientStyleOne" );
  });
});
