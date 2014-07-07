require 'spec_helper'

module Shepherd
  RSpec.describe GitBranch do
    def git
      Git.open(Dir.pwd.gsub(/shepherd.*/, "shepherd"))
    end

    describe ".current" do
      it "returns the current branch" do
        expect(GitBranch.current).to eq(git.lib.branch_current)
      end
    end

    describe ".changes" do
      it "returns the changes between the current branch and master" do
        changes = GitBranch.changes
        canonical = git.log.between("master")
        expect(changes.length).to eq(canonical.size)
        canonical.each_with_index do |commit, index|
          expect(changes[index]).to include(commit.sha[0..6])
          # some commits may have a multiline commits that the command line
          # properly handles but the git gem includes completely -- we only
          # want the first line
          expect(changes[index]).to include(commit.message.split("\n").first)
        end
      end

      it "can diff other branches" do
        # not the strongest test
        expect(GitBranch.changes(GitBranch.current).length).to eq(0)
      end
    end

    describe ".diff_command" do
      it "returns the right command" do
        branch = Faker::Lorem.word
        expect(GitBranch.diff_command(branch)).to eq(
          "git log #{branch}..HEAD --oneline"
        )
      end
    end
  end
end
