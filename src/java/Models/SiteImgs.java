package Models;
// Generated 12 oct. 2019 20:12:48 by Hibernate Tools 4.3.1



/**
 * SiteImgs generated by hbm2java
 */
public class SiteImgs  implements java.io.Serializable {


     private Integer id;
     private Sites sites;
     private String path;

    public SiteImgs() {
    }

    public SiteImgs(Sites sites, String path) {
       this.sites = sites;
       this.path = path;
    }
   
    public Integer getId() {
        return this.id;
    }
    
    public void setId(Integer id) {
        this.id = id;
    }
    public Sites getSites() {
        return this.sites;
    }
    
    public void setSites(Sites sites) {
        this.sites = sites;
    }
    public String getPath() {
        return this.path;
    }
    
    public void setPath(String path) {
        this.path = path;
    }




}


