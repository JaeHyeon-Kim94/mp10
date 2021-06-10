<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<html>
<head>
<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
	function fncGetList(currentPage) {
		$("#currentPage").val(currentPage)
		$("form").attr("method","GET").attr("action","/purchase/listPurchase").submit();
	}
	
	$(function(){
		
	$("td:contains('수령확인')").on("click", function(){
		alert("..");
		var prodNo = $(this).next().val();
		alert(prodNo);
		self.location = "/purchase/updateTranCode?prodNo="+prodNo+"&menu=manage&tranCode=3";
	});
	
	$(".ct_list_pop td:nth-child(1)").on("click",function(){
		
		var tranNo = $(this).text().trim();
		
		self.location = "/purchase/getPurchaseByTranNo?tranNo="+tranNo;
		
	});
	
	$(".ct_list_pop td:nth-child(3)").on("click",function(){
		var userId = $(this).text().trim();
		
		self.location = "/user/getUser?userId="+userId;
		
	});

});
</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm" action="/listPurchase.do" method="post">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">전체 ${resultPage.totalCount } 건수, 현재 ${resultPage.currentPage } 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원ID</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">전화번호</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	<c:set var="i" value="0"/>
	<c:forEach var="purchase" items="${list }">
		<c:set var="i" value="${i+1 }" />
		<tr class="ct_list_pop">
		<td align="center">
		<c:if test="${empty purchase.tranCode || purchase.tranCode == '1  '}">
			<a href="/purchase/getPurchaseByTranNo?tranNo=${purchase.tranNo}">${purchase.tranNo}</a>
		</c:if>
		<c:if test="${purchase.tranCode == '2  ' || purchase.tranCode== '3  ' }">
			${purchase.tranNo}
		</c:if>
		</td>
		<td></td>
		<td align="left">
			${purchase.buyer.userId}
		</td>
		<td></td>
		<td align="left">${purchase.receiverName}</td>
		<td></td>
		<td align="left">${purchase.receiverPhone}</td>
		<td></td>
		<td align="left">
			<c:if test= "${empty purchase.tranCode}">
			판매중
			</c:if>
			<c:if test= "${purchase.tranCode=='1  '}">
			구매완료
			</c:if>
			<c:if test= "${purchase.tranCode=='2  '}">
			배송중
			</c:if>
			<c:if test= "${purchase.tranCode=='3  '}">
			배송완료
			</c:if>
		</td>
		<td></td>
		
			<c:if test= "${purchase.tranCode=='2  '}">
			<td align="left">
				<a href="#">수령확인</a>
			</td>
			<input type=hidden name = "prodNo" value ="${purchase.purchaseProd.prodNo}"/>
			</c:if>
		
		
	</tr>
	<tr>
		<td id="${purchase.tranNo}" colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	</c:forEach>

</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr>
		<td align="center">
		<td align="center"><input type="hidden" id="currentPage"
						name="currentPage" value="" /> 
					<input type="hidden" name="menu" value="${menu}"/>
					<c:import var="page" url="../common/pageNavigator.jsp"/>
					${page}
					</td>
	</tr>
</table>

<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>