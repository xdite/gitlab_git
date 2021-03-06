require "spec_helper"

describe Gitlab::Git::Tree do
  let(:repository) { Gitlab::Git::Repository.new(TEST_REPO_PATH) }
  let(:tree) { Gitlab::Git::Tree.where(repository, ValidCommit::ID) }

  it { tree.should be_kind_of Array }
  it { tree.empty?.should be_false }
  it { tree.select(&:dir?).size.should == 10 }
  it { tree.select(&:file?).size.should == 16 }
  it { tree.select(&:submodule?).size.should == 0 }

  describe :dir do
    let(:dir) { tree.select(&:dir?).first }

    it { dir.should be_kind_of Gitlab::Git::Tree }
    it { dir.id.should == 'ba18d73c8fa3a326a5779b75bda0384dfb360240' }
    it { dir.commit_id.should == ValidCommit::ID }
    it { dir.name.should == 'app' }
    it { dir.path.should == 'app' }

    context :subdir do
      let(:subdir) { Gitlab::Git::Tree.where(repository, ValidCommit::ID, dir.name).first }

      it { subdir.should be_kind_of Gitlab::Git::Tree }
      it { subdir.id.should == '38f45392ae61f0effa84048f208a81019cc306bb' }
      it { subdir.commit_id.should == ValidCommit::ID }
      it { subdir.name.should == 'assets' }
      it { subdir.path.should == 'app/assets' }
    end
  end

  describe :file do
    let(:file) { tree.select(&:file?).first }

    it { file.should be_kind_of Gitlab::Git::Tree }
    it { file.id.should == '87c3f5a1c158686373e3179b503b0a7b7987587b' }
    it { file.commit_id.should == ValidCommit::ID }
    it { file.name.should == '.foreman' }
  end
end

