function swapicontitle(inputtitle, replacetitle) {
    var images = document.getElementsByTagName('IMG');

    if (images == null) return;
    var key;
    var testtitle;
    for (key in images) {
        testtitle = images[key].title;
        if (testtitle != undefined && testtitle.indexOf(inputtitle) == 0) {
            images[key].title = replacetitle;
            images[key].alt = replacetitle;
        }
    }
}

﻿
function notenterpressed(e) 
{
    var keynum

    if (window.event) // IE
    {
        keynum = e.keyCode;
    }
    else if (e.which) // Netscape/Firefox/Opera
    {
        keynum = e.which;
    }
    return (keynum==13)? false: true;
}
