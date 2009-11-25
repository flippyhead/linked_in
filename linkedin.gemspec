# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{linkedin}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter T. Brown"]
  s.date = %q{2009-11-04}
  s.description = %q{a gem for accessing the linkedin API}
  s.email = ["peter@pathable.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/linkedin.rb", "lib/linkedin/base.rb", "lib/linkedin/oauth.rb", "lib/linkedin/request.rb", "linkedin.gemspec", "script/console", "script/destroy", "script/generate", "spec/fixtures/connections.xml", "spec/fixtures/empty.xml", "spec/fixtures/error.xml", "spec/fixtures/network.xml", "spec/fixtures/people.xml", "spec/fixtures/profile.xml", "spec/linkedin/base_spec.rb", "spec/linkedin/oauth_spec.rb", "spec/linkedin/request_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.homepage = %q{http://github.com/#{github_username}/#{project_name}}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{linkedin}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{FIX (describe your package)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
