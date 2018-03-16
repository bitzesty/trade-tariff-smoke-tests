require 'smoke_tests/version'
require 'optparse'

module SmokeTests
  module Configuration
    class Parser
      def self.parse(args)
        opts = OptionParser.new do |parser|
          parser.separator ""
          parser.separator "Specific options:"

          parser.on("-e", "--environment ENVIRONMENT", [:local, :dev, :staging, :production], "This field requires one of a set of predefined values be set", "valid arguments are [local dev staging production]") do |setting|
            Base.environment = setting
          end

          parser.on("-l", "--list x,y", Array, "This command flag takes a comma separated list of urls(without", "spaces) This requires at least one argument.") do |setting|
            puts 'Not yet implemented'
            exit
            # Configuration.list_of_urls = setting
          end

          parser.on("--[no-]verbose", "This is a common boolean flag, setting verbosity to either", "true or false.") do |setting|
            Base.verbose = setting
          end

          parser.on('-m', "--max_concurrency NUM", Integer, "Set the number of concurrent requests.") do |setting|
            Base.max_concurrency = setting
          end

          parser.on_tail("-h", "--help", "--usage", "Show this usage message and quit.") do |setting|
            puts <<-'EOF'

              .______    __  .___________. ________   _______      _______..___________.____    ____
              |   _  \  |  | |           ||       /  |   ____|    /       ||           |\   \  /   /
              |  |_)  | |  | `---|  |----``---/  /   |  |__      |   (----``---|  |----` \   \/   /
              |   _  <  |  |     |  |        /  /    |   __|      \   \        |  |       \_    _/
              |  |_)  | |  |     |  |       /  /----.|  |____ .----)   |       |  |         |  |
              |______/  |__|     |__|      /________||_______||_______/        |__|         |__|


            EOF
            puts parser.help
            exit
          end

          parser.on_tail("-v", "--version", "Show version information about this gem and quit.") do
            puts "Smoke tests version #{SmokeTests::VERSION}"
            exit
          end
        end

        opts.parse!(args)
      end
    end
  end
end
