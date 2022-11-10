var db=require("../core/db.js");
var httpMsgs=require("../core/httpMsgs.js");
var bodyParser=require("body-parser");
var encryption=require("crypto-js/sha256")
var session=require('express-session');
var express=require("express");
var app=express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));
//Using Session for Login (Server side session with encryption)
app.use(session({secret:"SecretKeyNotPredictable",resave:false,saveUninitialized:true }));


//REPORT AVERAGE SEARCH
exports.Report_Average=function(req,res)
{
	var query="exec Report_Average '"+req.body.fromDate+"','"+req.body.toDate+"';";
	db.executeSql(query,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}else{
				if(data.recordset.length===0)
				{
					var respond=([{"EmplID":0}]);
					httpMsgs.sendJSON(req,res,respond);
				}
				else
				{
					httpMsgs.sendJSON(req,res,data.recordset);
				}
			}
	});
}



//LEAVE APPLICATION -ADMIN
exports.getApproveLeave=function(req,res)
{
	db.executeSql('exec GetApproveLeave;',function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}else{
			httpMsgs.sendJSON(req,res,data.recordset);
			}
			
	});
}


exports.searchApproveLeave=function(req,res)
{
	var dat="exec Report_Search_Approve '%"+req.body.pattern+"%';";
	db.executeSql(dat,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}else
		{
				if(data.recordset.length===0)
				{
					var respond=([{"EmplID":0}]);
					httpMsgs.sendJSON(req,res,respond);
				}
				else
				{
					httpMsgs.sendJSON(req,res,data.recordset);
				}
		}	
	});
}



//BALANCE REPORT - ADMIN
exports.getBalanceLeave=function(req,res)
{
	db.executeSql('exec Report_Balance;',function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}else{
			httpMsgs.sendJSON(req,res,data.recordset);
			}
	});
}

exports.searchBalanceLeave=function(req,res)
{
	var dat='exec Report_Search_Balance \'%'+req.body.pattern+'%\'\;';
	db.executeSql(dat,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else
		{
				if(data.recordset.length===0)
				{
					var respond=([{"EmplID":0}]);
					httpMsgs.sendJSON(req,res,respond);
				}
				else
				{
					httpMsgs.sendJSON(req,res,data.recordset);
				}
		}	
	});
}

