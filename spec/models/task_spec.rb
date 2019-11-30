require 'rails_helper'

RSpec.describe Task, type: :model do
  describe "#save" do
    let(:user) { create :user }
    let(:task) { user.tasks.new(title: title, status: status) }
    subject { task.save }

    # About valid datas
    shared_context 'valid datas' do
      let(:title) { 'TEST EXAMPLE TITLE' }
      let(:status) { %i[todo doing done].sample }
    end

    context "when title and status are exist" do
      include_context 'valid datas'
      it { expect(task).to be_valid }
    end

    # About title
    shared_examples 'title is invalid' do
      it do
        expect(task).not_to be_valid
        expect(task.errors[:title]).to be_present
      end
    end

    context "when title is blank" do
      include_context 'valid datas'
      let(:title) { nil }
      it_behaves_like 'title is invalid'
    end

    context "when title is overlap with other title" do
      include_context 'valid datas'
      let(:title) { create(:task).title }
      it_behaves_like 'title is invalid'
    end

    # About status
    context "when status is null" do
      include_context 'valid datas'
      let(:status) { nil }
      it "is not valid" do
        expect(task).not_to be_valid
        expect(task.errors[:status]).to be_present
      end
    end
    
    describe "relations" do
      include_context 'valid datas'
      specify 'Tasks belongs to user' do
        task.user = nil
        expect(task).not_to be_valid
        expect(task.errors[:user]).to be_present
      end
    end
  end
end
