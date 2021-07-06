<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>


<html>
<head>
<title>상품등록</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script type="text/javascript" src="../javascript/calendar.js">
</script>
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>

<style>
.dragAndDropDiv {
                border: 2px dashed #92AAB0;
                width: 650px;
                height: 200px;
                color: #92AAB0;
                text-align: center;
                vertical-align: middle;
                padding: 10px 0px 10px 10px;
                font-size:200%;
                display: table-cell;
            }
            .progressBar {
                width: 200px;
                height: 22px;
                border: 1px solid #ddd;
                border-radius: 5px; 
                overflow: hidden;
                display:inline-block;
                margin:0px 10px 5px 5px;
                vertical-align:top;
            }
             
            .progressBar div {
                height: 100%;
                color: #fff;
                text-align: right;
                line-height: 22px; /* same as #progressBar height if we want text middle aligned */
                width: 0;
                background-color: #0ba1b5; border-radius: 3px; 
            }
            .statusbar{
                border-top:1px solid #A9CCD1;
                min-height:25px;
                width:99%;
                padding:10px 10px 0px 10px;
                vertical-align:top;
            }
            .statusbar:nth-child(odd){
                background:#EBEFF0;
            }
            .filename{
                display:inline-block;
                vertical-align:top;
                width:250px;
            }
            .filesize{
                display:inline-block;
                vertical-align:top;
                color:#30693D;
                width:100px;
                margin-left:10px;
                margin-right:5px;
            }
            .abort{
                background-color:#A8352F;
                -moz-border-radius:4px;
                -webkit-border-radius:4px;
                border-radius:4px;display:inline-block;
                color:#fff;
                font-family:arial;font-size:13px;font-weight:normal;
                padding:4px 15px;
                cursor:pointer;
                vertical-align:top
            }
</style>



<script type="text/javascript">

function fncAddProduct(){
	//Form 유효성 검증
 	var prodName 
// 	= document.detailForm.prodName.value;
	= $("input[name='prodName']").val();
	
	var prodDetail 
//	= document.detailForm.prodDetail.value;
	= $("input[name='prodDetail']").val();
	
	var manuDate 
//	= document.detailForm.manuDate.value;
	= $("input[name='manuDate']").val();
	
	var price
//	= document.detailForm.price.value;
	= $("input[name='price']").val();
	
	var file
	= $("input[name='fileName']").val();
	
	
	if(prodName == null || prodName.length<1){
		alert("상품명은 반드시 입력하여야 합니다.");
		return;
	}
	if(prodDetail == null || prodDetail.length<1){
		alert("상품상세정보는 반드시 입력하여야 합니다.");
		return;
	}
	if(manuDate == null || manuDate.length<1){
		alert("제조일자는 반드시 입력하셔야 합니다.");
		return;
	}
	if(price == null || price.length<1){
		alert("가격은 반드시 입력하셔야 합니다.");
		return;
	}
	
	$("form[name='detailForm']").attr("method", "POST").attr("action", "/product/addProduct").submit();
}

$(function(){
	
	 var objDragAndDrop = $(".dragAndDropDiv");
     
     $(document).on("dragenter",".dragAndDropDiv",function(e){
         e.stopPropagation();
         e.preventDefault();
         $(this).css('border', '2px solid #0B85A1');
     });
     
     $(document).on("dragover",".dragAndDropDiv",function(e){
         e.stopPropagation();
         e.preventDefault();
     });
     
     $(document).on("drop",".dragAndDropDiv",function(e){
         
         $(this).css('border', '2px dotted #0B85A1');
         e.preventDefault();
         var files = e.originalEvent.dataTransfer.files;
     
         handleFileUpload(files,objDragAndDrop);
     });
     
     $(document).on('dragenter', function (e){
         e.stopPropagation();
         e.preventDefault();
     });
     
     $(document).on('dragover', function (e){
       e.stopPropagation();
       e.preventDefault();
       objDragAndDrop.css('border', '2px dotted #0B85A1');
     });
     
     $(document).on('drop', function (e){
         e.stopPropagation();
         e.preventDefault();
     });
     
     //drag 영역 클릭시 파일 선택창
     objDragAndDrop.on('click',function (e){
         $('input[type=file]').trigger('click');
     });

     $('input[type=file]').on('change', function(e) {
         var files = e.originalEvent.target.files;
         handleFileUpload(files,objDragAndDrop);
     });
     
     function handleFileUpload(files,obj)
     {
        for (var i = 0; i < files.length; i++) 
        {
             var fd = new FormData();
             fd.append('file', files[i]);
      
             var status = new createStatusbar(obj); //Using this we can set progress.
             status.setFileNameSize(files[i].name,files[i].size);
 //            sendFileToServer(fd,status);
      
        }
     }
     
     var rowCount=0;
     function createStatusbar(obj){
             
         rowCount++;
         var row="odd";
         if(rowCount %2 ==0) row ="even";
         this.statusbar = $("<div class='statusbar "+row+"'></div>");
         this.filename = $("<div class='filename'></div>").appendTo(this.statusbar);
         this.size = $("<div class='filesize'></div>").appendTo(this.statusbar);
         this.progressBar = $("<div class='progressBar'><div></div></div>").appendTo(this.statusbar);
         this.abort = $("<div class='abort'>중지</div>").appendTo(this.statusbar);
         
         obj.after(this.statusbar);
      
         this.setFileNameSize = function(name,size){
             var sizeStr="";
             var sizeKB = size/1024;
             if(parseInt(sizeKB) > 1024){
                 var sizeMB = sizeKB/1024;
                 sizeStr = sizeMB.toFixed(2)+" MB";
             }else{
                 sizeStr = sizeKB.toFixed(2)+" KB";
             }
      
             this.filename.html(name);
             this.size.html(sizeStr);
         }
         
         this.setProgress = function(progress){       
             var progressBarWidth =progress*this.progressBar.width()/ 100;  
             this.progressBar.find('div').animate({ width: progressBarWidth }, 10).html(progress + "% ");
             if(parseInt(progress) >= 100)
             {
                 this.abort.hide();
             }
         }
         
         this.setAbort = function(jqxhr){
             var sb = this.statusbar;
             this.abort.click(function()
             {
                 jqxhr.abort();
                 sb.hide();
             });
         }
     }
	/*
     function sendFileToServer(formData,status)
     {
         var uploadURL = "/product/json/uploadFile"; //Upload URL
         var extraData ={}; //Extra Data.
         var jqXHR=$.ajax({
                 xhr: function() {
                 var xhrobj = $.ajaxSettings.xhr();
                 if (xhrobj.upload) {
                         xhrobj.upload.addEventListener('progress', function(event) {
                             var percent = 0;
                             var position = event.loaded || event.position;
                             var total = event.total;
                             if (event.lengthComputable) {
                                 percent = Math.ceil(position / total * 100);
                             }
                             //Set progress
                             status.setProgress(percent);
                         }, false);
                     }
                 return xhrobj;
             },
             url: uploadURL,
             type: "POST",
             contentType:false,
             processData: false,
             cache: false,
             data: formData,
             success: function(data){
                 status.setProgress(100);
      
                 //$("#status1").append("File upload Done<br>");           
             }
         }); 
      
         status.setAbort(jqXHR);
     }
   */  
 });
     
     

</script>



</head>

<body bgcolor="#ffffff" text="#000000">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">상품등록</td>
					<td width="20%" align="right">&nbsp;</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif"	width="12" height="37"/>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 13px;">
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			상품명 <imgsrc="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle">
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="105">
						<input type="text" name="prodName" class="ct_input_g" 
									style="width: 100px; height: 19px" maxLength="20">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			상품상세정보 <img	src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">
			<input type="text" name="prodDetail" class="ct_input_g" 
						style="width: 100px; height: 19px" maxLength="10" minLength="6"/>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			제조일자 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">
			<input type="text" name="manuDate" readonly="readonly" class="ct_input_g"  
						style="width: 100px; height: 19px"	maxLength="10" minLength="6"/>
				&nbsp;<img src="../images/ct_icon_date.gif" width="15" height="15" 
										onclick="show_calendar('document.detailForm.manuDate', document.detailForm.manuDate.value)"/>
		</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>
	<tr>
		<td width="104" class="ct_write">
			가격 <img src="/images/ct_icon_red.gif" width="3" height="3" align="absmiddle"/>
		</td>
		<td bgcolor="D6D6D6" width="1"></td>
		<td class="ct_write01">
			<input type="text" name="price" 	class="ct_input_g" 
						style="width: 100px; height: 19px" maxLength="10">&nbsp;원
		</td>
	</tr>
	<tr>
		<td height="1" colspan="3" bgcolor="D6D6D6"></td>
	</tr>

</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td width="53%"></td>
		<td align="right">
		<table border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="17" height="23">
					<img src="/images/ct_btnbg01.gif" width="17" height="23"/>
				</td>
				<td background="/images/ct_btnbg02.gif" class="ct_btn01"  style="padding-top: 3px;">
					<a href="#">등록</a>
				</td>
				<td width="14" height="23">
					<img src="/images/ct_btnbg03.gif" width="14" height="23"/>
				</td>
				<td width="30"></td>
				<td width="17" height="23">
					<img src="/images/ct_btnbg01.gif" width="17" height="23"/>
				</td>
				<td background="/images/ct_btnbg02.gif" class="ct_btn01"	 style="padding-top: 3px;">
					<a href="#">취소</a>
				</td>
				<td width="14" height="23">
					<img src="/images/ct_btnbg03.gif" width="14" height="23"/>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

</form>
<form name="imgform">
        <div id="fileUpload" class="dragAndDropDiv">Drag & Drop Files Here or Browse Files</div>
        <input type="file" name="fileUpload" id="fileUpload" style="display:none;" multiple/>
</form>

</body>
</html>