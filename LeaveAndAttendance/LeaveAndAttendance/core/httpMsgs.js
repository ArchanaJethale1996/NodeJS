var settings= require("../settings.js");

exports.show500=function(req,res,err){
	if(settings.httpMsgsFormat==="HTML"){
		res.writeHead(500,"Internal Error occured",{"Content-Type":"text/html"});
		res.write("<html><head><title>500</title></head><body>500:Internal Error Occured. Details "+err+"</body></html>");	
	}
	else{
		res.writeHead(500,"Internal Error occured",{"Content-Type":"application/json"});
			res.write(JSON.stringify({ data:"Error Occured "+err}))
	}
	res.end();	
}

exports.sendJSON=function(req,res,data){
	res.writeHead(200,{"Content-Type":"application/json"});
	if(data){
		res.write(JSON.stringify(data));	
	}
	res.end();	
}

exports.show405=function(req,res){
	if(settings.httpMsgsFormat==="HTML"){
		res.writeHead(405,"Internal Error occured",{"Content-Type":"text/html"});
		res.write("<html><head><title>405</title></head><body>405:Method not supported.</body></html>");
			
	}
	else{
		res.writeHead(405,"Method not supported ",{"Content-Type":"application/json"});
		res.write(JSON.stringify({ data:"Error Occured "}))
	}
	res.end();	
}

exports.show404=function(req,res){
	if(settings.httpMsgsFormat==="HTML"){
		res.writeHead(404,"Internal Error occured",{"Content-Type":"text/html"});
		res.write("<html><head><title>404</title></head><body>404:Resource Not Found.</body></html>");
			
	}
	else{
		res.writeHead(404,"Resource Not Found ",{"Content-Type":"application/json"});
		res.write(JSON.stringify({ data:"Error Occured "}))
	}
	res.end();	
}



exports.show413=function(req,res){
	if(settings.httpMsgsFormat==="HTML"){
		res.writeHead(413,"Request Entity too Large",{"Content-Type":"text/html"});
		res.write("<html><head><title>405</title></head><body>413:Request Entity too Large. </body></html>");
			
	}
	else{
		res.writeHead(413,"Request Entity too Large",{"Content-Type":"application/json"});
		res.write(JSON.stringify({ data:"Error Occured "}))
	}
	res.end();	
}


exports.send200=function(req,res,err){
	res.writeHead(200,{"Content-Type":"application/json"});
	res.end();	
}
