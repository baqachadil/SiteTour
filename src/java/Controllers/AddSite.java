/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Models.SiteImgs;
import Models.Sites;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import javax.faces.context.FacesContext;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

/**
 *
 * @author ADIL LOTHBROK
 */
@WebServlet(name = "AddSite", urlPatterns = {"/AddSite"})
@MultipartConfig
public class AddSite extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        SessionFactory sf=new Configuration().configure().buildSessionFactory();
        Session s=sf.openSession();
        Transaction tr=s.beginTransaction();
        
        //get inputs value
        String name=request.getParameter("name");
        String description=request.getParameter("desc");
        
        float lat=Float.parseFloat(request.getParameter("lat"));
        float lng=Float.parseFloat(request.getParameter("lng"));
        
        Sites site1=new Sites(name,description,lat,lng);
        s.save(site1);
        
        
        /*ServletContext sc=(ServletContext) FacesContext.getCurrentInstance().getExternalContext().getContext();
        String HomeImgs = sc.getRealPath("Images");*/
        //upload images 
        
        List<Part> fileParts = request.getParts().stream().filter(part -> "file".equals(part.getName())).collect(Collectors.toList()); // Retrieves <input type="file" name="file" multiple="true">

        for (Part filePart : fileParts) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // MSIE fix.
            InputStream fileContent = filePart.getInputStream();
       
            /* byte[] buffer = new byte[fileContent.available()];
            fileContent.read(buffer);*/
            
            Files.copy(fileContent, new File("C:\\Users\\18\\Desktop\\JEE\\SiteTour\\web\\photos\\", fileName).toPath());
            /*Path path = Paths.get("C:\\Users\\18\\Desktop\\JEE\\SiteTour\\web\\photos\\"+fileName);
            Files.createFile(path);
            File targetFile = new File("‪‪‪D:\\photos\\"+fileName);
            OutputStream outStream = new FileOutputStream(targetFile);
            outStream.write(buffer);*/
            SiteImgs photo1=new SiteImgs(site1,"photos/"+fileName);
            s.save(photo1);
    }
        s.getTransaction().commit();
        response.sendRedirect("index.html");
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">

     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
