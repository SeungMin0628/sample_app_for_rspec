require 'rails_helper'

RSpec.describe Task, type: :model do
  describe '#save' do
    let(:task) { build :task }
    subject { task.save }

    # About valid datas
    context 'when title and status are exist' do
      it { expect(task).to be_valid }
    end

    # About title
    context 'when title is blank' do
      it 'is invalid' do
        task.title = nil
        expect(task).not_to be_valid
        expect(task.errors[:title]).to include 'can\'t be blank'
      end
    end

    context 'when title is overlap with other title' do
      it 'is invalid' do
        other_task = create :task
        task.title = other_task.title
        expect(task).not_to be_valid
        expect(task.errors[:title]).to include 'has already been taken'
      end
    end

    # About status
    context 'when status is null' do
      it 'is invalid' do
        task.status = nil
        expect(task).not_to be_valid
        expect(task.errors[:status]).to include 'can\'t be blank'
      end
    end

    describe 'relations' do
      specify 'Tasks belongs to user' do
        task.user = nil
        expect(task).not_to be_valid
        expect(task.errors[:user]).to include 'must exist'
      end
    end
  end
end
