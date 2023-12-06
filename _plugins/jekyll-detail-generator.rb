module Jekyll
    class JekyllDetailGenerator < Generator
        def generate(site)
            data = site.config["detail_page_gen"]
            if data
                data.each do |spec|
                    collection = spec["collection"]
                    layout = spec["layout"]
                    title_property = spec["title_property"]
                    url_property = spec["url_property"]
                    children_property = spec["children_property"]
                    
                    site.collections[collection].docs.each do |collection|
                        collection.data[children_property].each do |element|
                            site.pages << DetailPage.new(site, element, collection.data["name"], layout, element[title_property], element[url_property])
                        end
                    end
                end
            end
        end
    end
    
    class DetailPage < Page
        def initialize(site, item, collection_name, layout, title, url)
            @site = site             # the current site instance.
            @base = site.source      # path to the source directory.
            @dir  = collection_name + "/" + url        # the directory the page will reside in.

            # All pages have the same filename, so define attributes straight away.
            @basename = 'index'      # filename without the extension.
            @ext      = '.html'      # the extension.
            @name     = 'index.html' # basically @basename + @ext.
            
            self.process(@name)
            base_path = @site.layouts[layout].path
            base_path.slice! @site.layouts[layout].name
            self.read_yaml(base_path, @site.layouts[layout].name)
            
            self.data["item"] = item
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