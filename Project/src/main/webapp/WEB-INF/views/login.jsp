<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

</head>
	<jsp:include page="/resources/include/navigation.jsp" />
<script src="./resources/js/login.js" ></script>	
	


	 <!--  section01 -->
	<header class="masthead bg-primary text-white text-center">
    <div class="container d-flex align-items-center flex-column">
      
      <h1 class="masthead-heading text-uppercase mb-0">로그인</h1>
      <div id="loginDiv" align="center">
      <form onsubmit="return loginformchk()" action="<%=request.getContextPath()%>/loginok.do">
      	<table>
      		<tr>
      			<th>user ID</th>
      			<td><input class="input" name="j_id" id ="j_id"></td> 
      		</tr>
      		
      		<tr>
      			<th>password</th>
      			<td><input class="input" type="password" name="j_pwd" id="j_pwd" ></td>
      		</tr>
      	</table>
      	<input id="loginBtn" type="submit" value="Login"><br>
      	<input  id="loginBtn" type="button" value="find_Id" onclick="location.href='id_search.do'" >
      	<input  id="loginBtn" type="button" value="find_pwd" onclick="location.href='pwd_search.do'">
      	</form>
      </div>
    </div>
  </header>
  
  
  <jsp:include page="/resources/include/footer.jsp" />
  <jsp:include page="/resources/include/copyright.jsp" />
  <jsp:include page="/resources/include/modals.jsp" />	<%-- modal.jsp 끝에 js 파일 있어서 반응형 웹이 됩니다~ 마지막에 꼭 넣으십쏘~ --%>

</html>