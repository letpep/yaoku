	$(document).ready(function(){
	
		$('#Upload').click(function(){
		var form = new FormData(document.getElementById("upfile"))
		  $.ajax({  
			type: "POST",  
			url:'upfile',
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
			var categoryid = $("#categoryid").val();
			  $.ajax({  
					type: "POST",  
					url:'publish',
					data:JSON.stringify({"lurl":lurlval,"subject":subjectval,"categoryid":categoryid}),
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
