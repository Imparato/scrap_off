require 'rest-client';require 'base64';require 'json'; require 'date'

def update_blog_post(slug, content, publish = true)
  # b = BlogPost.find_by(slug: slug)
  # b.published = publish
  # b.published_at = Date.today
  # b.content = content
  # b.save!
  #
  puts "maj #{slug}, #{content.size} bytes, #{publish ? 'with publish' : 'unpublish'}"
end

def get_content(url)
  json = RestClient.get url, {:Authorization => "token a37436ac8f35de1f84af67565cbc56bb9385815b"}
  Base64.decode64(JSON.parse(json.body)["content"]).force_encoding('UTF-8')
end

def update_articles_off(date = Date.today)
  # créé un fichier
  return if date < Date.new(2021, 07, 07)
  day = date.day.to_s
  day = 99 if date > Date.new(2021, 07, 31)
  slugs = {
    demain: "quelle-piece-voir-demain-au-festival-off-d-avignon",
    jour: "quelle-piece-voir-aujourd-hui-au-festival-off-d-avignon",
    theatres:"tous-les-spectacles-du-off-2021-aujourd-hui-theatre-par-theatre"
  }
  today_md = tomorrow_md = theatre_md = ""

  # get today content
  url = "https://api.github.com/repos/imparato/scrap_off/contents/today/#{date.day}.md"
  update_blog_post(slugs[:jour], get_content(url))

  # update théâtre
  url = "https://api.github.com/repos/imparato/scrap_off/contents/theatres/#{date.day}.md"
  update_blog_post(slugs[:theatres], get_content(url), day <= 31)

  # update tomorrow
  if day < 31
    url = "https://api.github.com/repos/imparato/scrap_off/contents/tomorrow/#{date.day + 1}.md"
    update_blog_post(slugs[:demain], get_content(url))
  else
    update_blog_post(slugs[:demain], '### Article fermé', false)
  end

end


update_articles_off(Date.new(2021, 07, 13))
