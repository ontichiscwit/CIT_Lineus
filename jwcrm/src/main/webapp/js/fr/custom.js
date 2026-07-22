$(document).ready(function(){
    // 체크박스 디자인
    $('input[type="checkbox"]').after('<span class="icons custom-checkbox"></span>');
    
    // footer 고정일때 본문 패딩
    $('#footer.fix').siblings('#contents').css({paddingBottom : '64px'});
    
    // 약관 전체선택
    $('.check-all').click(function(){
        if($(this).find('input').prop('checked')){
            $(this).closest('.agreements').find('input').prop('checked', true);
        } else{
            $(this).closest('.agreements').find('input').prop('checked', false);
        }
    });
    
    //사업자등록번호 조회
    $('.search-number').click(function(){
        $('.search-result').css({display : 'block'});
    });
    $('.search-ok').click(function(){
        var searchResultNum = $(this).closest('.modal').find('input.search-result-number').val();
        var searchResultSName = $(this).closest('.modal').find('input.search-result-shopname').val();
        var searchResultAddress = $(this).closest('.modal').find('input.search-result-address').val();
        $('.result-target .search-result-number').val(searchResultNum);
        $('.result-target .search-result-shopname').val(searchResultSName);
        $('.result-target .search-result-address').val(searchResultAddress);
    });
    
    //메인 슬라이드메뉴
    $('.menu-hamburger').click(function(){
        $('.aside').fadeIn(500);
        $('.wrap-side').animate({right : 0}, 500);
    });
    $('.aside-blank').click(function(){
        $('.aside').fadeOut(500);
        $('.wrap-side').animate({right : '-300px'}, 500);
    });
    
    // 이미지 첨부
    $('.upload-img img').each(function(){
        $(this).load(function(){
            var deviceWidth = $(document).width() - 30;
            var imgWidth = this.naturalWidth;
            var imgHeight = this.naturalHeight;
            var imgPercent = deviceWidth / imgWidth;
            var marginTop = imgHeight * imgPercent
            $('.test-value').val(marginTop)
            $(this).css({
                marginTop : '-' + marginTop/2 + 'px'
            })
            $('.view-img').click(function(){
                var imgAdress = $(this).find('img').attr('src')
                var deviceWidthFull = $(document).width();
                var deviceHeightFull = $(window).height();
                var imgPercentWidth = deviceWidthFull / imgWidth;
                var imgPercentHeight = deviceHeightFull / imgHeight;
                var marginTopBig = imgHeight * imgPercentWidth;
                var marginLeftBig = imgWidth * imgPercentHeight;
                $('.view-img-big img').attr('src', imgAdress);
                if( imgWidth >= imgHeight ){
                    $('.view-img-big img').css({
                        width : '100%',
                        height : 'auto',
                        top : '50%',
                        marginTop : '-' + marginTopBig/2 + 'px'
                    });
                } else{
                    $('.view-img-big img').css({
                        height : '100%',
                        width : 'auto',
                        left : '50%',
                        marginLeft : '-' + marginLeftBig/2 + 'px'
                    })
                };
            });
        });
    });
});