var db=require("../core/db.js");
//exec used to execute stored procedure
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

//HOME
exports.getLogin= function(req,res){
	//Encrypt Password using SHA 256
	var password1=encryption(req.body.password1).toString();
	db.executeSql('exec GetLogin \''+req.body.username+'\',\''+password1+'\';',function(data,err){
		if(err){ 
			httpMsgs.show500(req,res,err);
		}else{
			if(data.recordset.length==0)
			{
				var respond={"credential_emp":"No record"}
				httpMsgs.sendJSON(req,res,respond);	
			}
			else 
			{
				req.session.user=data.recordset[0].FirstName;
				req.session.LastName=data.recordset[0].LastName;
				req.session.EmplID=data.recordset[0].EmplID;
				req.session.designation=data.recordset[0].designation;
				req.session.credential_emp=data.recordset[0].credential_emp;
				httpMsgs.sendJSON(req,res,data.recordset[0]);
			}
		}
	});
}

//CHECK ATTENDANCE
exports.getAttendanceMonth=function(req,res)
{
	var x="exec Get_Month_Attendance '"+req.body.fromdate+"','"+req.body.toDate+"',"+req.session.EmplID+";"
	db.executeSql(x,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
			httpMsgs.sendJSON(req,res,data.recordset);
			}	
	});
} 

//Mark Attendance
exports.MarkAttendance=function(req,res)
{
	var dat="exec MarkAttendance "+req.session.EmplID+",'"+req.body.date_attendance+"','"+req.body.starttime+"','"+req.body.stoptime+"'";
	db.executeSql(dat,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
				httpMsgs.send200(req,res);
			}		
	});
}

exports.CheckAttendanceMark=function(req,res)
{
	var dat="exec CheckAttendanceMark "+req.session.EmplID+",'"+req.body.date_attendance+"';";
	db.executeSql(dat,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
				httpMsgs.sendJSON(req,res,data.recordset);
			}	
	});
}

exports.ChangeAttendanceMark=function(req,res)
{
	var dat="exec ChangeAttendanceMark "+req.body.EmplID+",'"+req.body.date_attendance+"','"+req.body.starttime+"','"+req.body.stoptime+"'";
	db.executeSql(dat,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
				httpMsgs.sendJSON(req,res,data.recordset);
			}
	});
}


//LEAVE APPLICATION
exports.CanApplyLeave=function(req,res)
{
	db.executeSql('exec CanApplyLeave '+req.session.EmplID+',"'+req.body.leavetype+'";',function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
			httpMsgs.sendJSON(req,res,data.recordset);
			}
			
	});
}

exports.BalanceLeave=function(req,res)
{
	db.executeSql('exec LeaveBalanceRead '+req.session.EmplID,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
			httpMsgs.sendJSON(req,res,data.recordset);
			}
	});
}

exports.LeaveAppInsert=function(req,res)
{
	var dat="exec InsertLeaveTable "+req.session.EmplID+",'"+req.body.fromdate+"','"+req.body.toDate+"',"+req.body.noofdays+",'"+req.body.Reason+"','"+req.body.TypeOfLeave+"','"+req.body.type1+"';";
	db.executeSql(dat,function(data,err){
		if(err){
			httpMsgs.show500(req,res,err);
		}
		else{
				httpMsgs.send200(req,res);
			}
			
	});
}



