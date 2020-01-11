$(document).on('turbolinks:load', function(){
  const $posts_list = $('#posts_list');  //コンテナとなる要素を指定
  
  $posts_list.imagesLoaded(function(){   //imagesLoadedを使用し、画像が読み込みまれた段階でMasonryの関数を実行させる
    //Masonryの関数↓
    $posts_list.masonry({      //オプション指定箇所
      itemSelector: '.post_item',  //コンテンツを指定
      columnWidth: 155,    //カラム幅を設定
      fitWidth: true,          //コンテンツ数に合わせ親の幅を自動調整
    });
  });
});