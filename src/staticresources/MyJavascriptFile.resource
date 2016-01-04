$('#table-2 td').each(function() {
    if(parseInt($(this).html())>0){
    $(this).addClass("higherthan100");
    }else if (parseInt($(this).html())< 0){
    $(this).addClass("lowerthan100");
    }    
 });

