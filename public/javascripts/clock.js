function clock(){

time = new Date ();
secs = time.getSeconds();
sec = -1.57 + Math.PI * secs/30;
mins = time.getMinutes();
min = -1.57 + Math.PI * mins/30;
hr = time.getHours();
hrs = -1.57 + Math.PI * hr/6 + Math.PI*parseInt(time.getMinutes())/360;

if (NS6){
Ypos=window.pageYOffset+window.innerHeight-YCbase-25;
Xpos=window.pageXOffset+window.innerWidth-XCbase-30;
for (i=1; i < cdots+1; i++){
 document.getElementById("n6Digits"+i).style.top=Ypos-15+YCbase*Math.sin(-1.56 +i *Split*Math.PI/180)
 document.getElementById("n6Digits"+i).style.left=Xpos-15+XCbase*Math.cos(-1.56 +i*Split*Math.PI/180)
 }
for (i=0; i < S.length; i++){
 document.getElementById("Nx"+i).style.top=Ypos+i*YCbase/4.1*Math.sin(sec);
 document.getElementById("Nx"+i).style.left=Xpos+i*XCbase/4.1*Math.cos(sec);
 }
for (i=0; i < M.length; i++){
 document.getElementById("Ny"+i).style.top=Ypos+i*YCbase/4.1*Math.sin(min);
 document.getElementById("Ny"+i).style.left=Xpos+i*XCbase/4.1*Math.cos(min);
 }
for (i=0; i < H.length; i++){
 document.getElementById("Nz"+i).style.top=Ypos+i*YCbase/4.1*Math.sin(hrs);
 document.getElementById("Nz"+i).style.left=Xpos+i*XCbase/4.1*Math.cos(hrs);
 }
}
if (NS4){
Ypos=window.pageYOffset+window.innerHeight-YCbase-20;
Xpos=window.pageXOffset+window.innerWidth-XCbase-30;
for (i=0; i < cdots; ++i){
 document.layers["nsDigits"+i].top=Ypos-5+YCbase*Math.sin(-1.045 +i*Split*Math.PI/180)
 document.layers["nsDigits"+i].left=Xpos-15+XCbase*Math.cos(-1.045 +i*Split*Math.PI/180)
 }
for (i=0; i < S.length; i++){
 document.layers["nx"+i].top=Ypos+i*YCbase/4.1*Math.sin(sec);
 document.layers["nx"+i].left=Xpos+i*XCbase/4.1*Math.cos(sec);
 }
for (i=0; i < M.length; i++){
 document.layers["ny"+i].top=Ypos+i*YCbase/4.1*Math.sin(min);
 document.layers["ny"+i].left=Xpos+i*XCbase/4.1*Math.cos(min);
 }
for (i=0; i < H.length; i++){
 document.layers["nz"+i].top=Ypos+i*YCbase/4.1*Math.sin(hrs);
 document.layers["nz"+i].left=Xpos+i*XCbase/4.1*Math.cos(hrs);
 }
}

if (IE4){
Ypos=document.body.scrollTop+window.document.body.clientHeight-YCbase-20;
Xpos=document.body.scrollLeft+window.document.body.clientWidth-XCbase-20;
for (i=0; i < cdots; ++i){
 ieDigits[i].style.pixelTop=Ypos-15+YCbase*Math.sin(-1.045 +i *Split*Math.PI/180)
 ieDigits[i].style.pixelLeft=Xpos-15+XCbase*Math.cos(-1.045 +i *Split*Math.PI/180)
 }
for (i=0; i < S.length; i++){
 x[i].style.pixelTop =Ypos+i*YCbase/4.1*Math.sin(sec);
 x[i].style.pixelLeft=Xpos+i*XCbase/4.1*Math.cos(sec);
 }
for (i=0; i < M.length; i++){
 y[i].style.pixelTop =Ypos+i*YCbase/4.1*Math.sin(min);
 y[i].style.pixelLeft=Xpos+i*XCbase/4.1*Math.cos(min);
 }
for (i=0; i < H.length; i++){
 z[i].style.pixelTop =Ypos+i*YCbase/4.1*Math.sin(hrs);
 z[i].style.pixelLeft=Xpos+i*XCbase/4.1*Math.cos(hrs);
 }
}

