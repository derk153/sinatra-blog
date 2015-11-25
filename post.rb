class Post
  attr_reader :date

  def initialize(name)
      @name = name
      begin
        content = File.read("posts/#{name}.md")
      rescue
        return
      end

      match = content.match(/^---$(.*?)^---$(.*)/m)

      unless match.nil?
        meta_data = match[1]
        @content_raw = match[2]

        meta_data = YAML.load(meta_data)

        @title = meta_data["title"]
        @date = meta_data["date"]
      end

      # for older posts
      date_str = name.match(/^\d{4}-\d{2}-\d{2}/).to_s
      @date ||= Date.parse(date_str)
      @slug = name[/#{date_str}-?(.*)$/,1]
    end
end
