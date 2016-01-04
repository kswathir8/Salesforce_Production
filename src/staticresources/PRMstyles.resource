@charset "UTF-8";
/* CSS Document */
/* CSS Reset */
html * {	margin: 0 auto 0 auto; padding: 0; font-family: Helvetica, Arial, "Nimbus Sans L", sans-serif;}
body {
  font-size: 100%; /* Fixes exaggerated text resizing in IE6 and IE7 */
  background-color:#FFF;
}
#container {
  /* Use a 12px base font size with a 16px line height */
  font-size: 0.688em;
  line-height: 1.333em; /* 12px x 1.333 = 16px */
}
table {
  border-collapse: collapse;
  width: 100%; /* Prevent cramped-looking tables */
}
th,
thead th,
tbody th {
  text-align: left; /* LTR */
  padding: 0;
  border-bottom: none;
}
tbody {
  border-top: none;
}
/*
 * Images
 */
img {
  border: 0;
}
/*
 * Horizontal rules
 */
hr {
  height: 1px;
  border: 1px solid #666;
}
/*
 * Forms
 */
form {
  margin: 0;
  padding: 0;
}
fieldset {
  margin: 1em 0;
  padding: 0.5em;
}
/* Layout styles */
#wrapper {
  width:900px; 
  clear:both;
  margin:0 auto;
  position:relative;
}
#container {
  width:703px; 
  clear:both;
  margin:0 auto;
  position:relative;
  padding:0; 
  color:#000;
}
#columns {
  margin-top:10px;
}
#columns #column-first, #columns #column-last {
  float:left;
}
#column-first {
  width:401px;
}
#columns .column-inner {
  padding-right:6px;
}
#columns #column-first .light-box-top {
  min-height:167px;
}
#column-last{
 width:290px;
}
.light-box-left{
 background:transparent url(resource/PRMlightboxleft) no-repeat left top scroll;
 padding-left:9px;
}
.light-box-right{
  background:transparent url(resource/PRMlightboxright) no-repeat right top scroll;
  padding-right:14px;
}
.light-box-top{
  background:transparent url(resource/PRMlightboxtop) repeat-x left top scroll;
  padding:15px 20px 30px 5px;
}
#footer .light-box-left {
  background:transparent url(resource/PRMfooter_lightboxleft) no-repeat left top scroll;
  padding-left:10px;
}
#footer .light-box-top{
  min-height:100px;
  padding:15px 20px 0 5px;
}
#footer .light-box-right {
  background:transparent url(resource/PRMfooterlightboxright) no-repeat right top scroll;
}
.shade-box-left {
  background:transparent url(resource/PRMshadeboxleft) no-repeat left top scroll;
  padding-left:11px;
}
.shade-box-right {
  background:transparent url(resource/PRMshadeboxright) no-repeat right top scroll;
  padding-right:10px;
}
.shade-box-top {
  background:transparent url(resource/PRMshadeboxtop) repeat-x left top scroll;
  padding:15px 15px 0 10px;
  min-height:368px;
}
#container p {
  margin-bottom: 10px;
}
#column-first .content-box {
  border-bottom:1px solid #ededed;
}
.content-box {
  margin-bottom:15px;
}
/* clearfix */
.clearfix:after {
	clear: both;
	content: ' ';
	display: block;
	font-size: 0;
	line-height: 0;
	visibility: hidden;
	width: 0;
	height: 0;
}
.clearfix {
	display: inline-block;
}
* html .clearfix {
	height: 1%;
}
.clearfix {
	display: block;
}
/* content styles */
.column-inner h2 {
 font-family: Arial, Helvetica, sans-serif;
 font-size:1.273em;
 line-height:1.818em;
 font-weight:normal;
 text-transform:uppercase;
 margin-bottom:9px;
}
a {
 color:#20358c;
 text-decoration:none;
}
.image-link {
  display:block;
  text-align:center;
}
.more-link {
 display:inline-block;
 padding-right:11px;
 background:transparent url(resource/PRMarrowright_blue) no-repeat right top scroll;
 line-height:1.091em;
}
.inline-image-right {
 float:right;
 margin-left:5px;
}
#column-last p {
  padding-left:12px;
}
#footer ul {
 float:left;
 padding:10px 30px 0 30px;
}
#footer ul li {
  list-style:none;
  height:22px;
}
