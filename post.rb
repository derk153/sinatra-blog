class Post
  attr_reader :date
  attr_reader :name
  attr_reader :title
  attr_reader :category

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
        @category = meta_data["category"]
      end
    end
end
