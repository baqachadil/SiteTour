<%-- 
    Document   : Addsite
    Created on : 12 oct. 2019, 19:52:36
    Author     : ADIL LOTHBROK
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">
        <title>JSP Page</title>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-light bg-light">
            <a class="navbar-brand" href="#">SiteTour</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item ">
                        <a class="nav-link" href="GetSites">Sites touristiques <span class="sr-only"></span></a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="Addsite.jsp">Ajouter un Site<span class="sr-only">(current)</span></a>
                    </li>
                </ul>
            </div>
        </nav>
        <div class="card" style="text-align: center; width: 70%; margin-left: 15%; margin-top: 5%">
            <div class="card-header">
                <h3>Ajouter site</h3>
            </div>
            <div class="card-body">
                <form method="post" action="AddSite" enctype="multipart/form-data">
                    <input class="form-control" type="text" name="name" placeholder="Nom du site">
                    <textarea style="margin-top: 2%" class="form-control" name="desc" placeholder="Description"></textarea>
                    <input style="margin-top: 2%" class="form-control" multiple type="file" name="file" placeholder="Images">
                    <div id="map" style="width:100%;height:400px;margin-top: 2%"></div>
                    <input type="text" id="latitude" name="lat" hidden/>
                    <input type="text" id="longitude" name="lng" hidden/>
                    <input style="margin-top: 2%" class="form-control btn btn-primary" type="submit" value='Ajouter'>        
                </form>
            </div>                        
        </div>
    </body>    

    <script>

        var markersArray = [];
        function initMap() {
            var map = new google.maps.Map(document.getElementById('map'), {
                zoom: 10,
                center: {lat: 31.630000, lng: -8.008889}
            });

            map.addListener('click', function (e) {
                placeMarkerAndPanTo(e.latLng, map);
            });
        }

        function placeMarkerAndPanTo(latLng, map) {

            for (var i = 0; i < markersArray.length; i++)
                markersArray[i].setMap(null);
            var marker = new google.maps.Marker({
                position: latLng,
                map: map
            });
            var lat = document.getElementById("latitude").value = marker.getPosition().lat();
            var lng = document.getElementById("longitude").value = marker.getPosition().lng();
            console.log(document.getElementById("latitude").value);
            markersArray.push(marker);
            map.panTo(latLng);
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

    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBP10haOFmUjFi_NdhN0aPSKqGDAQJhxFg&callback=initMap"></script>    
</html>
