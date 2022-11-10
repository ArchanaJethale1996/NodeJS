//LISTENS FOR REQUEST
var http=require("http");
var settings=require("../settings.js")
var emp=require("../controllers/employee_action.js");
var admin=require("../controllers/admin_action.js");
var httpMsgs=require("./httpMsgs.js");
var bodyParser=require("body-parser");
var express=require("express");
var app=express();
var session=require('express-session');
app.set("view engine","ejs");
app.use(express.static("public"));
//Session Secret Key - Server Side Session
app.use(session({secret:"SecretKeyNotPredictable",resave:false,saveUninitialized:true }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: true}));

//------------------------ Employee ------------------------
//For main Action Go to employee_action.js

//Home
app.get("/",function(req,res){
	res.render("home");
})

app.post("/getLogin",function(req,res){
	emp.getLogin(req,res);
})

app.get("/employee",function(req,res){
	if(!req.session.user){
		return res.status(401).send();
	}
	else
		res.render("employee");
})


app.get("/admin",function(req,res){	
	if(!req.session.user){
		return res.status(401).send();
	}
	else
		res.render("admin");
})

app.get("/getSessionUser",function(req,res){
	res.writeHead(200,{"Content-Type":"application/json"});
	var credential_emp=req.session.credential_emp;
	var LastName=req.session.LastName;
	var user=req.session.user;
	var EmplID=req.session.EmplID;
	var designation=req.session.designation;
	res.write(JSON.stringify({'user':user,'LastName':LastName,'EmplID':EmplID,'designation':designation,'credential_emp':credential_emp}));	
	res.end();	
})


//CHECK ATTENDANCE
app.post("/getAttendanceMonth",function(req,res){
	emp.getAttendanceMonth(req,res);
})


//MARK ATTENDANCE
app.post("/CheckAttendanceMark",function(req,res){
	emp.CheckAttendanceMark(req,res);
})

app.put("/ChangeAttendanceMark",function(req,res){
	emp.ChangeAttendanceMark(req,res);
})

app.post("/MarkAttendance",function(req,res){
	emp.MarkAttendance(req,res);
})

//LEAVE APPLICATION - EMPLOYEE
app.get("/BalanceLeave",function(req,res){
	emp.BalanceLeave(req,res);
})

app.post("/CanApplyLeave",function(req,res){
	emp.CanApplyLeave(req,res);
})

app.post("/LeaveAppInsert",function(req,res){
	emp.LeaveAppInsert(req,res);
})

//------------------------ Admin ------------------------
//For main Action Go to admin_action.js
//BALANCE
app.post("/searchBalanceLeave",function(req,res){
	admin.searchBalanceLeave(req,res);
})


app.get("/getBalanceLeave",function(req,res){
	admin.getBalanceLeave(req,res);
})

//LEAVE APPLICATION - ADMIN
app.get("/getApproveLeave",function(req,res){
	admin.getApproveLeave(req,res);
})

app.post("/searchApproveLeave",function(req,res){
	admin.searchApproveLeave(req,res);
})

//AVERAGE REPORT SEARCH USING TWO DATE
app.post("/Report_Average",function(req,res){
	admin.Report_Average(req,res);
})

//LOGOUT
app.get("/logout",function(req,res){
	req.session.user="";
	req.session.LastName="";
	req.session.EmplID="";
	req.session.designation="";
	req.session.credential_emp="";
	req.session.destroy();
	res.header('Cache-Control', 'private, no-cache, no-store, must-revalidate');
	res.redirect("/");
})

//LISTEN TO REQUEST
app.listen(5000,'10.99.99.172',function(){
	console.log("Server Started!!");
})