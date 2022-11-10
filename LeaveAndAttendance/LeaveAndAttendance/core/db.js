var mssql = require('mssql');
var settings=require("../settings.js");
exports.executeSql= function(sql,callback)
{
	mssql.connect(settings.dbConfig, function (err) {
    if (err) 
	{
		console.log(err);
		callback(null,err);
		
	}	
    // Create Request object
    var request = new mssql.Request();
	 request.query(sql, function (err, recordset, fields) {
			if ( err ){
				console.log(err);
				callback(null,err);
				mssql.close();
			} else {
				callback(recordset);
				mssql.close();
			}
		});
	})
}
