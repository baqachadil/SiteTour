<%-- 
    Document   : AllSites
    Created on : 13 oct. 2019, 13:38:15
    Author     : ADIL LOTHBROK
--%>

<%@page import="Models.SiteImgs"%>
<%@page import="org.hibernate.Query"%>
<%@page import="org.hibernate.Transaction"%>
<%@page import="org.hibernate.Session"%>
<%@page import="org.hibernate.cfg.Configuration"%>
<%@page import="org.hibernate.SessionFactory"%>
<%@page import="java.util.List"%>
<%@page import="Models.Sites"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link href="css/bootstrap.min.css" rel="stylesheet" type="text/css">        
        <link href="css/test.css" rel="stylesheet" type="text/css">
        <script src="https://kit.fontawesome.com/3c123771d3.js" crossorigin="anonymous"></script>
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
                    <li class="nav-item active">
                        <a class="nav-link" href="GetSites">Sites touristiques <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="Addsite.jsp">Ajouter un Site</a>
                    </li>
                </ul>
            </div>
        </nav>
        <div style="width: 90%; margin: auto; margin-top: 2%;">          
            <form method="post" action="VoirSites">
                <div class="row">
                    <div class="col-md-10"></div>
                    <div class="col-md-2">
                        <button class="btn form-control btn-outline-primary" type="submit">Voir dans map ></button>
                    </div>
                </div>
                <div class="row">
                    <%
                        Sites selectedSite;
                        List<String> selectedImages;
                        List<Sites> L = (List<Sites>) session.getAttribute("List");
                        for (int i = 0; i < L.size(); i++) {
                            SessionFactory sf = new Configuration().configure().buildSessionFactory();
                            Session s = sf.openSession();
                            Transaction tr = s.beginTransaction();
                            Query q2 = s.createQuery("from SiteImgs where site_id= :site_id");
                            q2.setParameter("site_id", L.get(i).getId());
                            List<SiteImgs> images = (List<SiteImgs>) q2.list();
                    %>
                    <div class="col-md-3" style="margin-top: 2%">
                        <div class="card" style="width: 18rem;">
                            <img style="height: 200px" src="<%= images.get(0).getPath()%>" class="card-img-top" >
                            <label style="position: absolute; top: 0;" class="toggle"><input class="toggle__input" type="checkbox" name="site" value=<%= L.get(i).getId()%>><span class="toggle__label"><span class="toggle__text"></span></span></label>
                            <div class="card-body" >
                                <h5 class="card-title"><%= L.get(i).getNom()%></h5>                                  
                                <div style="height: 50px; overflow-y: hidden">
                                    <span style="" class="card-text"><%= L.get(i).getDescription()%></span>
                                </div>
                                <div style="margin-top: 2%" class="row">
                                    <div class="col-md-6">
                                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#infos<%= L.get(i).getId()%>"><i class="fas fa-info-circle"></i> Details</button>
                                    </div>
                                    <div class="col-md-6">
                                        <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#maps<%= L.get(i).getId()%>" onclick="javascript:initm(<%= L.get(i).getId()%>,<%= L.get(i).getLat()%>,<%= L.get(i).getLng()%>)"><i class="fas fa-map-marked-alt"></i> Position</button>
                                    </div>
                                </div>
                            </div>                            
                        </div>                                                        
                    </div>

                    <div class="modal fade bd-example-modal-lg" id="infos<%= L.get(i).getId()%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="title"> <%= L.get(i).getNom()%></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div id="SiteImgs<%= i%>" class="carousel slide" data-ride="carousel">
                                        <div class="carousel-inner">
                                            <% for (int j = 0; j < images.size(); j++) {
                                                    if (j == 0) {
                                            %>
                                            <div class="carousel-item active">
                                                <img style="height: 300px" src="<%= images.get(j).getPath()%>" class="d-block w-100" alt="...">
                                            </div>
                                            <% } else {%>
                                            <div class="carousel-item">
                                                <img style="height: 300px" src="<%= images.get(j).getPath()%>" class="d-block w-100" alt="...">
                                            </div>
                                            <% } %>
                                            <% }%>
                                        </div>
                                        <a class="carousel-control-prev" href="#SiteImgs<%= i%>" role="button" data-slide="prev">
                                            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Previous</span>
                                        </a>
                                        <a class="carousel-control-next" href="#SiteImgs<%= i%>" role="button" data-slide="next">
                                            <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                            <span class="sr-only">Next</span>
                                        </a>
                                    </div>
                                    <div>
                                        <p> <%= L.get(i).getDescription()%> </p>
                                    </div>    
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="modal fade bd-example-modal-lg" id="maps<%= L.get(i).getId()%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="title"> Position de <%= L.get(i).getNom()%></h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>
                                <div class="modal-body">
                                    <div id="SiteImgs<%= i%>" class="carousel slide" data-ride="carousel">
                                        <div id="latitude" hidden> <%= L.get(i).getLat()%> </div>
                                        <div id="longitude" hidden> <%= L.get(i).getLng()%> </div>
                                        <div id="SiteId" hidden> <%= L.get(i).getId()%> </div>
                                        <div id="map<%= L.get(i).getId()%>" style="width:100%;height:400px"></div>  
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                    </div>
                                </div>
                            </div>
                        </div>  
                    </div>                    

                    <%
                        }
                    %>
                </div>                    
            </form>    
        </div>                       
        <script src="https://code.jquery.com/jquery-2.1.0.min.js" type="text/javascript"></script> 
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>        
        <script>

                                            var markersArray = [];
                                            var latitude = 0;
                                            var longitude = 0;
                                            var id = 0;
                                            function initm(i, lt, lg)
                                            {
                                                latitude = parseFloat(lt);
                                                longitude = parseFloat(lg);
                                                id = parseInt(i);
                                                initMap();
                                            }
                                            function initMap() {
                                                var map = new google.maps.Map(document.getElementById('map' + id), {
                                                    zoom: 15,
                                                    center: {lat: latitude, lng: longitude}
                                                });
                                                setMarker(latitude, longitude, map);
                                            }

                                            function setMarker(lt, lg, map) {
                                                marker = new google.maps.Marker({
                                                    position: {lat: parseFloat(lt), lng: parseFloat(lg)},
                                                    map: map
                                                });
                                                markersArray.push(marker);
                                                map.panTo({lat: parseFloat(lt), lng: parseFloat(lg)});
                                            }

                                            // Store old reference
                                            const appendChild = Element.prototype.appendChild;

                                            const urlCatchers = [
                                                "/AuthenticationService.Authenticate?",
                                                "/QuotaService.RecordEvent?"
                                            ];

                                            Element.prototype.appendChild = function (element) {
                                                const isGMapScript = element.tagName === 'SCRIPT' && /maps\.googleapis\.com/i.test(element.src);
                                                const isGMapAccessScript = isGMapScript && urlCatchers.some(url => element.src.includes(url));

                                                if (!isGMapAccessScript) {
                                                    return appendChild.call(this, element);
                                                }
                                                return element;
                                            };
        </script>

        <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBP10haOFmUjFi_NdhN0aPSKqGDAQJhxFg&callback"></script>
    </body>    
</html>
