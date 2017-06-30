require 'fileutils'
require 'puppet-lint/tasks/puppet-lint'
require 'puppetlabs_spec_helper/rake_tasks'
require 'ra10ke'
require 'r10k/puppetfile'
require 'erb'

PuppetSyntax.app_management = true
PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')
PuppetLint.configuration.send('disable_140chars')
PuppetLint.configuration.send('disable_class_inherits_from_params_class')
PuppetLint.configuration.send('disable_documentation')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp", "bundle/**/*", "vendor/**/*"]

PuppetLint::RakeTask.new :lint do | config |
  config.fix = true
end


desc "Generate Fixtures files for role/profile"
task :generate_fixtures do
  ['role','profile'].each do |m|
    fixtures(File.dirname(__FILE__),m)
  end
end


# Most of this logic was lifted from onceover (comments and all) - thank you!
# https://github.com/dylanratcliffe/onceover/blob/98811bee7bf373e1a22706d98f9ccc1360aff482/lib/onceover/controlrepo.rb
def self.evaluate_template(template_name,bind)
  template_dir = File.expand_path('./scripts',File.dirname(__FILE__))
  template = File.read(File.expand_path("./#{template_name}",template_dir))
  ERB.new(template, nil, '-').result(bind)
end

def fixtures(controlrepo,sourcemod)

  # Load up the Puppetfile using R10k
  puppetfile = R10K::Puppetfile.new(controlrepo)
  fail 'Could not load Puppetfile' unless puppetfile.load
  modules = puppetfile.modules

  # Iterate over everything and seperate it out for the sake of readability
  symlinks = []
  forge_modules = []
  repositories = []

  modules.each do |mod|
    # This logic could probably be cleaned up. A lot.
    if mod.is_a? R10K::Module::Forge
      if mod.expected_version.is_a?(Hash)
        # Set it up as a symlink, because we are using local files in the Puppetfile
        symlinks << {
          'name' => mod.name,
          'dir' => mod.expected_version[:path]
        }
      elsif mod.expected_version.is_a?(String)
        # Set it up as a normal firge module
        forge_modules << {
          'name' => mod.name,
          'repo' => mod.title,
          'ref' => mod.expected_version
        }
      end
    elsif mod.is_a? R10K::Module::Git
      # Set it up as a git repo
      repositories << {
          'name' => mod.name,
          'repo' => mod.instance_variable_get(:@remote),
          'ref' => mod.version
        }
    end
  end

  symlinks << {
    'name' => "#{sourcemod}",
    'dir'  => '"#{source_dir}"',
  }

  content = evaluate_template('fixtures.yml.erb',binding)

  File.open("#{File.dirname(__FILE__)}/site/#{sourcemod}/.fixtures.yml",'w') do |f|
    f.write content
  end
end


