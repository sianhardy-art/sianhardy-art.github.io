module Jekyll
    class JekyllArtDetailGenerator < Generator
        def generate(site)
            site.collections["galleries"].docs.each do |gallery|
                gallery.data['arts'].each do |artwork|
                    site.pages << ArtDetailPage.new(site, artwork, gallery.data['name'])
                end
            end
        end
    end
    
    class ArtDetailPage < Page
        def initialize(site, artwork, gallery_name)
            @site = site             # the current site instance.
            @base = site.source      # path to the source directory.
            @dir  = gallery_name + "/" + artwork["order"]        # the directory the page will reside in.

            # All pages have the same filename, so define attributes straight away.
            @basename = 'index'      # filename without the extension.
            @ext      = '.html'      # the extension.
            @name     = 'index.html' # basically @basename + @ext.
            
            self.process(@name)
            base_path = @site.layouts["artdetail"].path
            base_path.slice! @site.layouts["artdetail"].name
            self.read_yaml(base_path, @site.layouts["artdetail"].name)
            
            self.data["image"] = artwork["image"]
            self.data["title"] = artwork["title"]
            self.data["artist"] = artwork["artist"]
            self.data["description"] = artwork["description"]
        end
    
        # Placeholders that are used in constructing page URL.
        def url_placeholders
            {
                :path       => @dir,
                :category   => @dir,
                :basename   => basename,
                :output_ext => output_ext,
            }
        end
    end
end