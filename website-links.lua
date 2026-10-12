-- Render canonical Markdown guides as website pages without changing GitHub docs.
local guide_page = false
local first_title = true
return {
  { Meta = function(meta)
      guide_page = meta["guide-page"] ~= nil
    end },
  { Header = function(header)
      if guide_page and first_title and header.level == 1 then
        first_title = false
        return {}
      end
    end,
    Link = function(link)
      if link.target:match("^%a[%w+.-]*:") then return link end
      link.target = link.target:gsub("README%.md", "guide.html")
        :gsub("sources%.md", "sources.html")
        :gsub("replication%-notes%.md", "replication-notes.html")
        :gsub("VALIDATION%.md", "validation.html")
        :gsub("docs/index%.html", "index.html")
      return link
    end }
}
