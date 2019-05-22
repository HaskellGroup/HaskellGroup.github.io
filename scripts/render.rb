require 'erb'
require 'rest-client'
require 'json'
require 'date'

def get_issues()
  api_url = 'https://api.github.com/repos/hskll/community/issues?labels=excellent%20topic'
  JSON.parse(RestClient.get api_url || []).map do |i|
    if i["updated_at"]
      date_obj = DateTime.strptime(i["updated_at"], '%Y-%m-%dT%H:%M:%SZ')
      i["updated_at"] = date_obj.strftime('%Y年%m月%d日%H:%M:%S')
    end
    i
  end
end

def get_template()
  File.read('./index.html.erb')
end

def render()
  ERB.new(get_template).result(binding)
end

def save(file)
  File.open(file, "w+") do |f|
    f.write(render)
  end
end

@issues = get_issues
save(File.join('../', 'index.html'))
