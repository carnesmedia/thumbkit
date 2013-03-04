# A sample Guardfile
# More info at https://github.com/guard/guard#readme

notification :off

guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec', version: 2, cli: '--color -f doc', keep_failed: false, all_on_start: false, all_after_pass: false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{ m[1] }_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

