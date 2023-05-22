        
        function getFrameHeight() {
           var height;

            if (document.body.offsetHeight){ //ns6 syntax
                    height = document.body.offsetHeight+30;
            }
            else if (document.body.scrollHeight){ //ie5+ syntax
                    height = document.body.scrollHeight+20;
            }
            return height;
        }
		   
	    function sendFrameResizeRequest() {
            var height;
            height = getFrameHeight();
            console.log(height);
            parent.postMessage (height, "*");
        }
			
		$(window).on('load', function ()  {
		    // window.load fires after document.ready.  document.ready is after full DOM is loaded
		    // but window.loat waits until any graphics and frames are drawn as well.
			
            $(window).resize(function(){
                sendFrameResizeRequest();
            });
            
            sendFrameResizeRequest();
            // send the resize request again 2.5 seconds later.  Had test cases where the request
            // was sent before styles applied somehow, and the frame wasn't big enough.
            setTimeout(() => {  sendFrameResizeRequest(); }, 2500);
            $(window).scrollTop(0);
        });
