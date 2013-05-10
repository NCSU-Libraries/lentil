# A sample Guardfile
# More info at https://github.com/guard/guard#readme



group :tests do
  guard :test do
    callback(:run_on_changes_begin) { puts "\n", '='*70, "\n" }

    watch(%r{^lib/(.+)\.rb$})     { |m| "test/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb$})
    watch('test/test_helper.rb')  { "test" }

    # admin
    watch(%r{^app/views/admin/.+/*rb})

    # changing any javascript triggers javascript integration tests
    watch(%r{^app/assets/javascripts/(.+)}) {|m| "test/integration/lentil/javascript"}

    # Rails example
    watch(%r{^app/models/(.+)\.rb$})                   { |m| "test/unit/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/(.+)\.rb$})              { |m| "test/functional/#{m[1]}_test.rb" }
    watch(%r{^app/views/.+\.rb$})                      { "test/integration" }
    watch('app/controllers/application_controller.rb') { ["test/functional", "test/integration"] }
  end
end
