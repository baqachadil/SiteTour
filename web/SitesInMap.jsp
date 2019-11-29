<%-- 
    Document   : SitesInMap
    Created on : 13 oct. 2019, 14:16:14
    Author     : ADIL LOTHBROK
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
        <title>JSP Page</title>
    </head>
    <img>
    <body>
        <nav style="position: absolute; top: 0; width: 100%" class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">SiteTour</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link" href="GetSites">Sites touristiques <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="Addsite.jsp">Ajouter un Site</a>
                    </li>
                </ul>
            </div>
        </nav>
        <div id="map" style="width:100%;height:600px;margin-top: 2%"></div>
    </body>    
    <script>
        var markersArray = [];
        var map;

        function initMap() {
            map = new google.maps.Map(document.getElementById('map'), {
                zoom: 10,
                center: {lat: 31.630000, lng: -8.008889}
            });


            setMarkers();
        }


        function setMarkers() {

            //var ss=["31.2345/-8.2344","31.2325/-8.2344"];
            var ss = [];
        <%
                    for (int i = 0; i < ((ArrayList<String>) session.getAttribute("coords")).size(); i++) {
        %>
            ss.push('<%= ((ArrayList<String>) session.getAttribute("coords")).get(i)%>');
        <%
                    }
        %>
            console.log(ss[0].split("_"));
            var iconBase = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/';

            var icons = {

                monument: {
                    icon: 'photos/tourisme.jpg'//iconBase + 'info-i_maps.png'
                }
            };

            var marker;
            var infowindow = new google.maps.InfoWindow();
            for (var i = 0; i < ss.length; i++) {
                var cords = ss[i].split("_");

                marker = new google.maps.Marker({
                    position: {lat: parseFloat(cords[0]), lng: parseFloat(cords[1])},
                    icon: icons['monument'].icon,
                    map: map
                });
                markersArray.push(marker);
                map.panTo({lat: parseFloat(cords[0]), lng: parseFloat(cords[1])});

                google.maps.event.addListener(marker, 'click', (function (marker, i) {
                    return function () {
                        infowindow.setContent('<img style="width:400px;height:400px;" src=' + ss[i].split("_")[2] + '>');
                        infowindow.open(map, marker);
                    };
                })(marker, i));

                if ((i + 1) < ss.length) {
                    var tocords = ss[i + 1].split("_");
                    /*  var lineCoordinates = [
                     {lat: parseFloat(cords[0]), lng: parseFloat(cords[1])},
                     {lat: parseFloat(tocords[0]), lng: parseFloat(tocords[1])}
                     ];
                     var linePath = new google.maps.Polyline({
                     path: lineCoordinates,
                     geodesic: true,
                     strokeColor: '#FF0000'
                     });                        
                     linePath.setMap(map);*/
                    var directionsService = new google.maps.DirectionsService();
                    var directionsRenderer = new google.maps.DirectionsRenderer();

                    var location1 = new google.maps.LatLng(parseFloat(cords[0]), parseFloat(cords[1]));
                    var location2 = new google.maps.LatLng(parseFloat(tocords[0]), parseFloat(tocords[1]));

                    // var map1 = new google.maps.Map(document.getElementById('map'), mapOptions);
                    directionsRenderer.setMap(map);

                    //calculateAndDisplayRoute(directionsService,directionsRenderer,location1, location2);
                    calcRoute(directionsService, directionsRenderer, location1, location2);
                }
            }

        }
        function  calculateAndDisplayRoute(directionsService, directionsDisplay, pointA, pointB) {
            directionsService.route({
                origin: pointA,
                destination: pointB,
                travelMode: google.maps.TravelMode.DRIVING
            }, function (response, status) {
                if (status == google.maps.DirectionsStatus.OK) {
                    directionsDisplay.setDirections(response);
                } else {
                    window.alert('Directions request failed due to ' + status);
                }
            });
        }


        function calcRoute(directionsService, directionsRenderer, start, end) {

            var request = {
                origin: start,
                destination: end,
                travelMode: 'DRIVING'
            };
            directionsService.route(request, function (result, status) {
                if (status == 'OK') {
                    directionsRenderer.setDirections(result);
                }
            });
        }


        // Store old reference
        const appendChild = Element.prototype.appendChild;

// All services to catch
        const urlCatchers = [
            "/AuthenticationService.Authenticate?",
            "/QuotaService.RecordEvent?"
        ];

// Google Map is using JSONP.
// So we only need to detect the services removing access and disabling them by not
// inserting them inside the DOM
        Element.prototype.appendChild = function (element) {
            const isGMapScript = element.tagName === 'SCRIPT' && /maps\.googleapis\.com/i.test(element.src);
            const isGMapAccessScript = isGMapScript && urlCatchers.some(url => element.src.includes(url));

            if (!isGMapAccessScript) {
                return appendChild.call(this, element);
            }

            // Extract the callback to call it with success data
            // Only needed if you actually want to use Autocomplete/SearchBox API
            //const callback = element.src.split(/.*callback=([^\&]+)/, 2).pop();
            //const [a, b] = callback.split('.');
            //window[a][b]([1, null, 0, null, null, [1]]);

            // Returns the element to be compliant with the appendChild API
            return element;
        };
    </script>

    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCL3qzgqg6P8crdHBcQMnOQo7KWFnOkpVs&callback=initMap"></script>
</html>
