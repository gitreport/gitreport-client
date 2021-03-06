# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gitreport"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jan Roesner"]
  s.date = "2011-11-22"
  s.description = "gitreport keeps track of your projects. It collects info about commited and pushed data, submits it to gitreport.com and provides a gorgous frontend to examine, discover and extract the data that you need to generate the payment recipes for your customers, measure your performance, find gaps and get an overview about your work. No longer searching or `what did I commit when and where`..."
  s.email = "jan@roesner.it"
  s.executables = ["gitreport"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/gitreport",
    "gitreport.gemspec",
    "lib/batch_sender.rb",
    "lib/commit.rb",
    "lib/configuration.rb",
    "lib/current_branch.rb",
    "lib/g_logger.rb",
    "lib/generic_sender.rb",
    "lib/git.rb",
    "lib/git/author.rb",
    "lib/git/base.rb",
    "lib/git/branch.rb",
    "lib/git/branches.rb",
    "lib/git/diff.rb",
    "lib/git/index.rb",
    "lib/git/lib.rb",
    "lib/git/log.rb",
    "lib/git/object.rb",
    "lib/git/path.rb",
    "lib/git/remote.rb",
    "lib/git/repository.rb",
    "lib/git/stash.rb",
    "lib/git/stashes.rb",
    "lib/git/status.rb",
    "lib/git/working_directory.rb",
    "lib/git_configuration.rb",
    "lib/gitreport.rb",
    "lib/history.rb",
    "lib/hook.rb",
    "lib/log.rb",
    "lib/project.rb",
    "lib/sender.rb",
    "lib/storage.rb",
    "lib/supplier.rb",
    "lib/trollop.rb",
    "spec/gitreport_spec.rb",
    "spec/models/batch_sender_spec.rb",
    "spec/models/commit_spec.rb",
    "spec/models/configuration_spec.rb",
    "spec/models/current_branch_spec.rb",
    "spec/models/git_configuration_spec.rb",
    "spec/models/history_spec.rb",
    "spec/models/hook_spec.rb",
    "spec/models/log_spec.rb",
    "spec/models/project_spec.rb",
    "spec/models/sender_spec.rb",
    "spec/models/storage_spec.rb",
    "spec/models/supplier_spec.rb",
    "spec/spec_helper.rb",
    "spec/support/fake_repository.rb",
    "templates/gitreport-post-commit.bash"
  ]
  s.homepage = "https://github.com/gitreport/gitreport-client"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.10"
  s.summary = "gitreport tracks your commits and pushes metadata to gitreport.com"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<spork>, ["> 0.9.0.rc"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<spork>, ["> 0.9.0.rc"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<spork>, ["> 0.9.0.rc"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.6.4"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

