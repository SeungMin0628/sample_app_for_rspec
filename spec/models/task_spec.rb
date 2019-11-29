require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "#save" do
    let(:task) { build(:task) }
    subject { task.save }

    context "when title and status are exist" do
      it { is_expected.to be_truthy }
    end

    context "when title is blank" do
      it "is not valid" do
        task.title = ''
        is_expected.to be_falsey
      end
    end

    context "when title is overlap with other title" do
      it "is not valid" do
        other_task = create :task
        task.title = other_task.title
        is_expected.to be_falsey
      end
    end

    context "when status is null" do
      it "is not valid" do
        task.status = nil
        is_expected.to be_falsey
      end
    end
    
    describe "relations" do
      specify 'Tasks belongs to user' do
        task.user = nil
        is_expected.to be_falsey
      end
    end
  end
end
