require 'thor'
require 'erb'
require 'ostruct'
require 'shepherd'

class Elo < Thor
  desc "pr TARGET", "Open a pull request against the target branch (master by default)"
  def pr(target = "master")
    Shepherd::PullRequest.new(target).open!
  end
end
