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
    build_fixtures(File.dirname(__FILE__),m)
  end
end


desc "Generate spec tests for missing classes"
task :generate_spec_tests do
  exit spec_gen(true)
end

desc "Get spec test status"
task :check_for_spec_tests do
  exit spec_gen
end



def spec_gen(create=false)
  exit_code = 0
  ['role','profile'].each do |m|
    # For role or profile, find all the classes
    classes = Array.new

    pattern = 'site/profile/manifests/*/*.pp' if m == 'profile'
    pattern = 'site/role/manifests/*.pp' if m == 'role'
    Dir.glob("#{pattern}").each do |f|
      File.open(f).read.each_line do |l|
        c = l.scan(/(\s+)?class\s+([a-zA-Z:_]+)\s+[\{,\(]/)
        # Add this class to the classes array
        classes.push(c[0][1]) if !c.empty?
      end
    end

    # For each class, see if a spec file exists - using naming convention
    # <class>_<subclass>[_<subclass>_]_spec.rb
    classes.each do |c|
      spec_file = "#{File.dirname(__FILE__)}/site/#{m}/spec/classes/#{c.split('::').join('_')}_spec.rb"

      # If no spec file exists, create a blank should compile test file
      if File.exists?(spec_file)
        puts "Class #{c} - Spec file already exists at #{spec_file}!" if create == true
      else
        if create == true
          puts "Class #{c} - Creating... #{spec_file}!"
          File.open(spec_file, 'w') do |f|
            f.write evaluate_template('spec_template.rb.erb',binding)
          end
        else
          puts "Class #{c} - Spec file missing!"
          exit_code = 1
        end
      end
    end
  end
  return exit_code
end

# Most of this logic was lifted from onceover (comments and all) - thank you!
# https://github.com/dylanratcliffe/onceover/blob/98811bee7bf373e1a22706d98f9ccc1360aff482/lib/onceover/controlrepo.rb
def evaluate_template(template_name,bind)
  template_dir = File.expand_path('./scripts',File.dirname(__FILE__))
  template = File.read(File.expand_path("./#{template_name}",template_dir))
  ERB.new(template, nil, '-').result(bind)
end

def build_fixtures(controlrepo,sourcemod)

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

  # If this is role, we need a symlink for profile
  if sourcemod == 'role'
    symlinks << {
      'name' => "profile",
      'dir'  => '"#{source_dir}/../profile"',
    }
  end

  File.open("#{File.dirname(__FILE__)}/site/#{sourcemod}/.fixtures.yml",'w') do |f|
    f.write evaluate_template('fixtures.yml.erb',binding)
  end
end


