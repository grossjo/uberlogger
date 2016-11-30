# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "uberlogger"
  s.version = "0.6.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Austin Ziegler", "Chayim I. Kirshen"]
  s.date = "2013-01-31"
  s.description = "This is a super logger, literally an uber-logger. The goal is to provide a\npython-like logging facility, with relatively simple to use logging\nfunctionality that supports multiple logging mechanisms.\n\n    x = UberLogger.instance.getLogger('logger-name')\n\n:include: Licence.rdoc"
  s.email = ["austin@surfeasy.com", "chayim@gnupower.net"]
  s.extra_rdoc_files = ["History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = [".gemtest", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "lib/uberlogger.rb", "uberlogger.gemspec", "test/test_uberlogger.rb", "test/test_uberlogger_class_methods.rb"]
  s.homepage = "https://github.com/austin-surfeasy/uberlogger"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "uberlogger"
  s.rubygems_version = "1.8.11"
  s.summary = "This is a super logger, literally an uber-logger"
  s.test_files = ["test/test_uberlogger.rb", "test/test_uberlogger_class_methods.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<log4r>, ["~> 1.1.0"])
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<minitest>, ["~> 4.5"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.10"])
    else
      s.add_dependency(%q<log4r>, ["~> 1.1.0"])
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<minitest>, ["~> 4.5"])
      s.add_dependency(%q<rdoc>, ["~> 3.10"])
    end
  else
    s.add_dependency(%q<log4r>, ["~> 1.1.0"])
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<minitest>, ["~> 4.5"])
    s.add_dependency(%q<rdoc>, ["~> 3.10"])
  end
end
