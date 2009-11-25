# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{linked_in}
  s.version = "0.0.21"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Peter T. Brown"]
  s.date = %q{2009-11-25}
  s.summary = %q{The linked_in gem wraps the LinkedIn API making it easy to read and write profile information and messages on http://linked_in.com. Full support for OAuth is provided including a wrapper for Pelle's oauth-plugin (http://github.com/pelle/oauth-plugin/). This gem borrowed heavily from junemakers twitter gem (http://github.com/jnunemaker/twitter/).}
  s.email = ["peter@pathable.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "docs/sample-oauth-plugin_token.rb", "lib/linked_in.rb", "lib/linked_in/base.rb", "lib/linked_in/oauth.rb", "lib/linked_in/request.rb", "linked_in.gemspec", "script/console", "script/destroy", "script/generate", "spec/fixtures/connections.xml", "spec/fixtures/connections_with_field_selectors.xml", "spec/fixtures/empty.xml", "spec/fixtures/error.xml", "spec/fixtures/network.xml", "spec/fixtures/people.xml", "spec/fixtures/profile.xml", "spec/linked_in/base_spec.rb", "spec/linked_in/oauth_spec.rb", "spec/linked_in/request_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/rspec.rake"]
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.homepage = "http://github.com/flippyhead/linked_in"
  s.rubygems_version = %q{1.3.5}
  s.description = %q{The linked_in gem wraps the LinkedIn API, including support for OAuth.}

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
