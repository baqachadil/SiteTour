/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Controllers;

import Models.SiteImgs;
import Models.Sites;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

/**
 *
 * @author ADIL LOTHBROK
 */
@WebServlet(name = "VoirSites", urlPatterns = {"/VoirSites"})
public class VoirSites extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            String[] ss=request.getParameterValues("site");
            ArrayList<String> AllSites=new ArrayList<>();
            for(int i=0;i<ss.length;i++){
                int id=Integer.parseInt(ss[i]);
                SessionFactory sf=new Configuration().configure().buildSessionFactory();
                Session s=sf.openSession();
                Transaction tr=s.beginTransaction();        
                Query q=s.createQuery("from Sites where id= :id");
                q.setParameter("id", id);
                Sites site=(Sites)q.list().get(0);
                Query q2=s.createQuery("from SiteImgs where site_id= :site_id");
                q2.setParameter("site_id", id);
                SiteImgs images=(SiteImgs)q2.list().get(0);
                String cords=site.getLat()+"_"+site.getLng()+"_"+images.getPath();
                AllSites.add(cords);
                tr.commit();
                s.close();
            }
            HttpSession hs=request.getSession();
            hs.setAttribute("coords", AllSites);
            response.sendRedirect("SitesInMap.jsp");
        }
        /*String[] ss=request.getParameterValues("site");
        ArrayList<String> L=new ArrayList<>();
        for (String s : ss) {
            L.add(s);
        }
        HttpSession hs=request.getSession();
        hs.setAttribute("coords", L);
        response.sendRedirect("SitesInMap.jsp");*/
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
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
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
