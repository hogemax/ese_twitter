$(function(){
  $('#repostModal').on('show.bs.modal', function (event) {
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
  })
});
