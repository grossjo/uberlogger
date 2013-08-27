# -*- ruby encoding: utf-8 -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :bundler
Hoe.plugin :doofus
Hoe.plugin :email
Hoe.plugin :gemspec
Hoe.plugin :git
Hoe.plugin :rubyforge
Hoe.plugin :minitest
Hoe.plugin :travis

spec = Hoe.spec 'uberlogger' do
  developer('Austin Ziegler', 'austin@surfeasy.com')
  developer('Chayim I. Kirshen', 'chayim@gnupower.net')

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList["*.rdoc"].to_a

  self.extra_deps << ['log4r', '~> 1.1.0']

  self.extra_dev_deps << ['minitest', '~> 2.0']
  self.extra_dev_deps << ['hoe-bundler', '~> 1.2']
  self.extra_dev_deps << ['hoe-doofus', '~> 1.0']
  self.extra_dev_deps << ['hoe-gemspec', '~> 1.0']
  self.extra_dev_deps << ['hoe-git', '~> 1.5']
  self.extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  self.extra_dev_deps << ['hoe-travis', '~> 1.2']
  self.extra_dev_deps << ['rake', '~> 10.0']
end

# vim: syntax=ruby
