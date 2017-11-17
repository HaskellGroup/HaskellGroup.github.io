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

class GitHubIssues
  include ERB::Util
  attr_accessor :issues, :template

  def initialize(issues, template)
    @issues = issues
    @template = template
  end

  def render()
    ERB.new(@template).result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end

end

issues = GitHubIssues.new(get_issues, get_template)
issues.save(File.join('../', 'index.html'))
