$(document).on('turbolinks:load', function() {
//$(function(){

  //モーダルを開いているかのフラグ
  var modalFlag = false;

  $('div#repostModal').on('show.bs.modal', function (event) {
    //投稿内容の初期化
    revertPostlook();
    //モーダル有効判定
    modalFlag = true;

    var button = $(event.relatedTarget) //モーダルを呼び出すときに使われたボタンを取得
    var post_itself = button.parent().parent()
    var post_id = post_itself.attr('id')
    var post_content = post_itself.find('span.content').text()
    var post_image
    //画像の取得
    (post_itself.find('div').find('img')) ? post_image = post_itself.find('div').find('img').attr('src'): post_image = "";
    var recipient = button.data('whatever') //data-whatever の値を取得

    //console.log(post_id)
    //console.log(post_content)

    var modal = $(this)  //モーダルを取得
    modal.find('.modal-title').text('Repost of ' + recipient) //モーダルのタイトルに値を表示
    var modal_source_div = modal.find('div.modal-body').find('div.well')
    modal_source_div.find('#repost_source_content').text(post_content)
    modal_source_div.find('#repost_source_id').val(post_id)
    var src_image_url
    (post_image) ? src_image_url = post_image: src_image_url = '';
    modal_source_div.find('#repost_source_image').attr('src', src_image_url);
  });

  //モーダルでのpostボタン装飾判定
  $('div.modal-dialog textarea#micropost_content').on('input click keypress blur', function(){
      var repostContents = $(this).val();
      var repostButton = $('form.new_micropost').find('input[name="commit"]');
      if(repostContents === "") {
        repostButton.removeClass( "btnAttractAttentionOne gradientStyleOne" );
      } else {
        repostButton.addClass( "btnAttractAttentionOne gradientStyleOne" );
      }
  });

  //「x」または「close」ボタンを押したとき
  $('button.close').on('click', revertPostlook);
  $('div.modal-footer button').on('click', revertPostlook);
  //モーダルを開いた状態で「esc」キーを押したとき
  $( "body" ).keydown(function( event ) {
    if ( event.which == 27 && modalFlag == true ) {
      revertPostlook();
    }
  });

  //内容を空にしてpostボタンの装飾クラスも除去
  function revertPostlook () {
    $('textarea#micropost_content').val("");
    $('form.new_micropost').find('input[name="commit"]').removeClass( "btnAttractAttentionOne gradientStyleOne" );
    //モーダル無効化
    modalFlag = false;
    //新規投稿ボタンの装飾も戻す
    $('aside.col-md-4 textarea#micropost_content').removeClass( "btnAttractAttentionOne gradientStyleOne" );
  }
});
