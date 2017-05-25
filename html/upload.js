	$(document).ready(function(){
	
		$('#Upload').click(function(){
		var form = new FormData(document.getElementById("upfile"))
		  $.ajax({  
			type: "POST",  
			url:'http://codeh.xyz/upfile',  
			data:form,   
			processData:false,
			contentType: false,
			error: function(request) {  
				alert("Connection error");  
			},  
			success: function(data) {  
				$("#lurl").val(data)		
				$("#publishTable").attr("style","dislpay:block;")
			}  
			});
		
		})
		
		$('.publish').click(function(){
			var lurlval = $("#lurl").val();
			var subjectval = $("#subject").val();
			  $.ajax({  
					type: "POST",  
					url:'http://codeh.xyz/publish',  
					data:JSON.stringify({"lurl":lurlval,"subject":subjectval}),   
					dataType:"json",
					error: function(request) {  
						alert("error");  
					},  
					success: function(data) { 
						alert("发布成功"); 
						location.reload();			
					}  
				});
		
		})
		
		

	});
