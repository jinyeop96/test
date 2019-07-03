<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    
<title>교통 검색</title>
	<style type="text/css">
		#map{
			width: 100%;
			height: 600px;
		}
	</style>
</head>



<body>
			
	<jsp:include page="/resources/include/navigation.jsp" />

	 <!--  section01 -->
	<header class="masthead bg-primary text-white text-center">
    	<div class="container d-flex align-items-center flex-column">
    	 
    	 	<jsp:include page="/resources/include/navigation.jsp" />
	
    <h1 class="masthead-heading text-uppercase mb-0">교통 검색</h1><br><br>
    
    

<p id="result"></p>				
<script>		
// map 생성
// Tmap.map을 이용하여, 지도가 들어갈 div, 넓이, 높이를 설정합니다.						
map = new Tmap.Map({
	div : "map_div", // map을 표시해줄 div
	width : "100%", // map의 width 설정
	height : "380px", // map의 height 설정
});
map.setCenter(new Tmap.LonLat("126.9850380932383", "37.566567545861645").transform("EPSG:4326", "EPSG:3857"), 15);//설정한 좌표를 "EPSG:3857"로 좌표변환한 좌표값으로 즁심점으로 설정합니다.

var routeLayer = new Tmap.Layer.Vector("route");//벡터 레이어 생성
var markerLayer = new Tmap.Layer.Markers("start");// 마커 레이어 생성
map.addLayer(routeLayer);//map에 벡터 레이어 추가
map.addLayer(markerLayer);//map에 마커 레이어 추가

// 시작
var size = new Tmap.Size(24, 38);//아이콘 크기 설정
var offset = new Tmap.Pixel(-(size.w / 2), -size.h);//아이콘 중심점 설정
var icon = new Tmap.IconHtml('<img src=http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_s.png />', size, offset);//마커 아이콘 설정
var marker_s = new Tmap.Marker(new Tmap.LonLat("126.9850380932383", "37.566567545861645").transform("EPSG:4326", "EPSG:3857"), icon);//설정한 좌표를 "EPSG:3857"로 좌표변환한 좌표값으로 설정합니다.
markerLayer.addMarker(marker_s);//마커 레이어에 마커 추가

// 도착
var icon = new Tmap.IconHtml('<img src=http://tmapapis.sktelecom.com/upload/tmap/marker/pin_r_m_e.png />', size, offset);//마커 아이콘 설정
var marker_e = new Tmap.Marker(new Tmap.LonLat("127.10331814639885", "37.403049076341794").transform("EPSG:4326", "EPSG:3857"), icon);//설정한 좌표를 "EPSG:3857"로 좌표변환한 좌표값으로 설정합니다.
markerLayer.addMarker(marker_e);//마커 레이어에 마커 추가

var headers = {}; 
headers["appKey"]="b1d19509-2c96-42da-94ae-cacf54e926c4";//실행을 위한 키 입니다. 발급받으신 AppKey(서버키)를 입력하세요.
$.ajax({
	method:"POST",
	headers : headers,
	url:"https://api2.sktelecom.com/tmap/routes?version=1&format=xml",//자동차 경로안내 api 요청 url입니다.
	async:false,
	data:{
		//출발지 위경도 좌표입니다.
		startX : "126.9850380932383",
		startY : "37.566567545861645",
		//목적지 위경도 좌표입니다.
		endX : "127.10331814639885",
		endY : "37.403049076341794",
		//출발지, 경유지, 목적지 좌표계 유형을 지정합니다.
		reqCoordType : "WGS84GEO",
		resCoordType : "EPSG3857",
		//각도입니다.
		angle : "172",
		//경로 탐색 옵션 입니다.
		searchOption : 0,
		//교통정보 포함 옵션입니다.
		trafficInfo : "N"
		
	},
	//데이터 로드가 성공적으로 완료되었을 때 발생하는 함수입니다.
	success:function(response){
		prtcl = response;
		
		// 결과 출력
		var innerHtml ="";
		var prtclString = new XMLSerializer().serializeToString(prtcl);//xml to String	
		xmlDoc = $.parseXML( prtclString ),
		$xml = $( xmlDoc ),
		$intRate = $xml.find("Document");
    	
		var tDistance = " 총 거리 : "+($intRate[0].getElementsByTagName("tmap:totalDistance")[0].childNodes[0].nodeValue/1000).toFixed(1)+"km,";
		var tTime = " 총 시간 : "+($intRate[0].getElementsByTagName("tmap:totalTime")[0].childNodes[0].nodeValue/60).toFixed(0)+"분,";	
		var tFare = " 총 요금 : "+$intRate[0].getElementsByTagName("tmap:totalFare")[0].childNodes[0].nodeValue+"원,";	
		var taxiFare = " 예상 택시 요금 : "+$intRate[0].getElementsByTagName("tmap:taxiFare")[0].childNodes[0].nodeValue+"원";	

		$("#result").text(tDistance+tTime+tFare+taxiFare);
		
		routeLayer.removeAllFeatures();//레이어의 모든 도형을 지웁니다.
				
		var traffic = $intRate[0].getElementsByTagName("traffic")[0];
		//교통정보가 포함되어 있으면 교통정보를 포함한 경로를 그려주고
		//교통정보가 없다면  교통정보를 제외한 경로를 그려줍니다.
		if(!traffic){
			var prtclLine = new Tmap.Format.KML({extractStyles:true, extractAttributes:true}).read(prtcl);//데이터(prtcl)를 읽고, 벡터 도형(feature) 목록을 리턴합니다.
			
			//표준 데이터 포맷인 KML을 Read/Write 하는 클래스 입니다.
			//벡터 도형(Feature)이 추가되기 직전에 이벤트가 발생합니다.
			routeLayer.events.register("beforefeatureadded", routeLayer, onBeforeFeatureAdded);
	        function onBeforeFeatureAdded(e) {
		        	var style = {};
		        	switch (e.feature.attributes.styleUrl) {
		        	case "#pointStyle":
			        	style.externalGraphic = "http://topopen.tmap.co.kr/imgs/point.png"; //렌더링 포인트에 사용될 외부 이미지 파일의 url입니다.
						style.graphicHeight = 16; //외부 이미지 파일의 크기 설정을 위한 픽셀 높이입니다.
						style.graphicOpacity = 1; //외부 이미지 파일의 투명도 (0-1)입니다.
						style.graphicWidth = 16; //외부 이미지 파일의 크기 설정을 위한 픽셀 폭입니다.
		        	break;
		        	default:
						style.strokeColor = "#ff0000";//stroke에 적용될 16진수 color
						style.strokeOpacity = "1";//stroke의 투명도(0~1)
						style.strokeWidth = "5";//stroke의 넓이(pixel 단위)
		        	};
	        	e.feature.style = style;
	        }
			
			routeLayer.addFeatures(prtclLine); //레이어에 도형을 등록합니다.
		}else{
			//기존 출발,도착지 마커릉 지웁니다.
			markerLayer.removeMarker(marker_s); 
			markerLayer.removeMarker(marker_e);
			routeLayer.removeAllFeatures();//레이어의 모든 도형을 지웁니다.
			
			//-------------------------- 교통정보를 그려주는 부분입니다. -------------------------- 
			var trafficColors = {
					extractStyles:true,
					
					/* 실제 교통정보가 표출되면 아래와 같은 Color로 Line이 생성됩니다. */
					trafficDefaultColor:"#000000", //Default
					trafficType1Color:"#009900", //원할
					trafficType2Color:"#8E8111", //지체
					trafficType3Color:"#FF0000"  //정체
					
				};    
			var kmlForm = new Tmap.Format.KML(trafficColors).readTraffic(prtcl);
			routeLayer = new Tmap.Layer.Vector("vectorLayerID"); //백터 레이어 생성
			routeLayer.addFeatures(kmlForm); //교통정보를 백터 레이어에 추가   
			
			map.addLayer(routeLayer); // 지도에 백터 레이어 추가
			//-------------------------- 교통정보를 그려주는 부분입니다. -------------------------- 
		}
		
		map.zoomToExtent(routeLayer.getDataExtent());//map의 zoom을 routeLayer의 영역에 맞게 변경합니다.	
	},
	//요청 실패시 콘솔창에서 에러 내용을 확인할 수 있습니다.
	error:function(request,status,error){
		console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	}
});



</script>
</div>
</header>


	<jsp:include page="/resources/include/footer.jsp" />
  	<jsp:include page="/resources/include/copyright.jsp" />
  	<jsp:include page="/resources/include/modals.jsp" />
	
</body>
</html>