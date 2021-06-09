<%@ page language="java" contentType="text/html; charset=EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	function fncGetList(currentPage) {

		
		$("#currentPage").val(currentPage)
		$("form").attr("method", "GET").attr("action", "/product/listProduct?menu=${menu}").submit();

	}

	function getProduct(prodNo){	
		
		if(${menu.equals("manage")}){
			
			self.location = "/product/updateProduct?prodNo="+prodNo
		}
		
		if(${menu.equals("search")}){
			self.location = "/product/getProduct?prodNo="+prodNo
		}
		
	}
	
	
	
	$(function(){

		
	$( "td.ct_btn01:contains('검색')" ).on("click" , function() {
		fncGetList(1);
	});
		
	$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {	
		
		getProduct($(this).prev().prev().html());
	});
		
$( ".ct_list_pop td:nth-child(3)" ).on("mouseenter" , function() {	
		var prodNo = $(this).prev().prev().html();
		$.ajax(
				{
						url : "/product/json/getProduct/"+prodNo ,
						method : "GET" ,
						dataType : "json" ,
						headers : {
							"Accept" : "application/json",
							"Content-Type" : "application/json"
						},
						success : function(JSONData, status){
							
							var displayValue = "<h3>"
													+"상품 번호 :"+ JSONData.prodNo+"<br/>"
													+"상 품 명 :"+ JSONData.prodName+"<br/>"
													+"가   격 :"+ JSONData.price+"<br/>"
													+"상세 정보 :"+ JSONData.prodDetail+"<br/>"
													+"제조 일자 :"+ JSONData.manuDate+"<br/>"
													+"등록 일자 :"+ JSONData.regDate +"<br/>"
							
							$( "#"+prodNo+"" ).html(displayValue);
						}
			
			
		});
	});
	
	$( ".ct_list_pop td:nth-child(3)" ).on("mouseenter" , function() {	
	
		$("h3").remove();
		
	});
	$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
	});
	
	
	
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

	<div style="width: 98%; margin-left: 10px;">

		<form name="detailForm">

			<table width="100%" height="37" border="0" cellpadding="0"
				cellspacing="0">
				<tr>
					<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"
						width="15" height="37" /></td>
					<td background="/images/ct_ttl_img02.gif" width="100%"
						style="padding-left: 10px;">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
							<c:if test="${!empty menu && menu == 'manage'}">
								<td width="93%" class="ct_ttl01">상품 관리</td>
							</c:if>
							<c:if test="${!empty menu && menu == 'search'}">
								<td width="93%" class="ct_ttl01">상품 목록조회</td>
							</c:if>
							
							</tr>
						</table>
					</td>
					<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"
						width="12" height="37" /></td>
				</tr>
			</table>

			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="right"><select name="searchCondition"
						class="ct_input_g" style="width: 80px">
							<option value="0"
								${!empty search.searchCondition && search.searchCondition == 0 ? "selected" : ""}>상품번호</option>
							<option value="1"
								${!empty search.searchCondition && search.searchCondition == 1 ? "selected" : ""}>상품명</option>
							<option value="2"
							${!empty search.searchCondition && search.searchCondition == 2 ? "selected" : ""}>상품가격</option>
					</select> <input type="text" name="searchKeyword" value="${search.searchKeyword}"
						class="ct_input_g" style="width: 200px; height: 19px" /></td>
					<td align="right" width="70">
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="17" height="23"><img
									src="/images/ct_btnbg01.gif" width="17" height="23"></td>
								<td background="/images/ct_btnbg02.gif" class="ct_btn01"
									style="padding-top: 3px;"><a
									href="#">검색</a></td>
								<td width="14" height="23"><img
									src="/images/ct_btnbg03.gif" width="14" height="23"></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>


			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td colspan="11">전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.currentPage}
						페이지
					</td>
				</tr>
				<tr>
					<td class="ct_list_b" width="100">No</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">상품명</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b" width="150">가격</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">등록일</td>
					<td class="ct_line02"></td>
					<td class="ct_list_b">현재상태</td>
				</tr>
				<tr>
					<td colspan="11" bgcolor="808285" height="1"></td>
				</tr>
				
				<c:set var="i" value="0" />
				<c:forEach var="product" items="${list}">
					<c:set var="i" value="${i+1}"/>
					<tr class="ct_list_pop">
						<td align="center" >${product.prodNo}</td>
						<td></td>
						<td align="left" >${product.prodName}</td>
						<td></td>
						<td align="left">${product.price}</td>
						<td></td>
						<td align="left">${product.manuDate}</td>
						<td></td>
						<td align="left">${product.proTranCode}</td>
						</tr>
						<tr>
					<td id="${product.prodNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
				</tr>
						</c:forEach>
			</table>
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0"
				style="margin-top: 10px;">
				<tr>
					<td align="center"><input type="hidden" id="currentPage"
						name="currentPage" value="" /> 
					<input type="hidden" name="menu" value="${menu}"/>
					<c:import var="page" url="../common/pageNavigator.jsp"/>
					${page}
					</td>
				</tr>
				<tr>
							
				</tr> 
			</table>
			<!--  페이지 Navigator 끝 -->

		</form>

	</div>
</body>
</html>
