function FindProxyForURL(url, host)
{
    url = url.toLowerCase();
    host = host.toLowerCase();
    
    // whole site
    var site_list = [
        ,'blogger.com'
        ,'blogspot.com'
        ,'bit.ly'
        ,'appspot.com'
        ,'quora.com'

        ,'feedburner.com'
        ,'flickr.com'
        ,'friendfeed.com'
        ,'facebook.com'
        ,'facebook.net'
        ,'fbcdn.net'
        
        ,'slideshare.net'

        ,'ggpht.com'
        ,'goo.gl'
        ,'google.com'
        ,'google.com.hk'
        ,'google.com.tw'
        ,'googleusercontent.com'
        ,'googlevideo.com'
        ,'gstatic.com'
        ,'googleapis.com'
        ,'googlegroups.com'
        
        ,'golang.org'
        
        ,'onedrive.live.com'

        ,'t.co'
        ,'twitgoo.com'
        ,'twitter.com'
        ,'twitpic.com'
        ,'twimg.com'
        ,'tweetphoto.com'
        ,'wordpress.com'

        ,'youtube.com'
        ,'youtu.be'
        
        ,'ytimg.com'
        ,'jquery.com'
        ,'tensorflow.org'
        ,'cnzz.com'
        ,'dropbox.com'
        ,'slack.com'
        
        

    ];
    
    var exp_list = [ ];

    for(var index = 0;index<site_list.length;index++){
         if(host==site_list[index] ||
             shExpMatch(host, "*." + site_list[index])){
            return "SOCKS5 127.0.0.1:7070";
         }
    }
    for(var index = 0;index<exp_list.length;index++){
        var re = new RegExp(exp_list[index]);
        if(url.match(re)){
            return "SOCKS5 127.0.0.1:7070";
        }
    }
    return "DIRECT";
}
