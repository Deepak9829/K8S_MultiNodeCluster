function op() {
    
    var ip = ipaddr();
    var xhr = new XMLHttpRequest();
    i=document.getElementById("box1").value
    xhr.open("GET","http://"+ip+"/cgi-bin/info.py?info="+i,true);
    xhr.send();

    xhr.onload=function(){
        var output = xhr.responseText;
    document.getElementById('output').innerHTML = output;
    }
}


function ipaddr()
{
var myip = document.getElementById("userInput").value;
return myip

}
