require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:sender) { create(:user) }
  let(:recipient) { create(:user) }
  let(:project) { create(:project) }

  describe 'associations' do
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:project).optional }
    it { should belong_to(:recipient).class_name('User').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(1).is_at_most(1000) }

    context 'must have project or recipient' do
      it 'is valid with a recipient and no project' do
        message = build(:message, sender: sender, recipient: recipient, project: nil)
        expect(message).to be_valid
      end

      it 'is valid with a project and no recipient' do
        message = build(:message, :project_message, sender: sender, project: project)
        expect(message).to be_valid
      end

      it 'is invalid without both project and recipient' do
        message = Message.new(sender: sender, content: 'Test', project: nil, recipient: nil)
        expect(message).not_to be_valid
        expect(message.errors[:base]).to include("Le message doit avoir soit un projet, soit un destinataire")
      end

      it 'is invalid with both project and recipient' do
        message = Message.new(sender: sender, content: 'Test', project: project, recipient: recipient)
        expect(message).not_to be_valid
        expect(message.errors[:base]).to include("Le message ne peut pas avoir à la fois un projet et un destinataire")
      end
    end
  end

  describe 'scopes' do
    describe '.unread' do
      it 'returns unread messages' do
        unread = create(:message, sender: sender, recipient: recipient, read_at: nil)
        read = create(:message, sender: sender, recipient: recipient, read_at: Time.current)

        expect(Message.unread).to include(unread)
        expect(Message.unread).not_to include(read)
      end
    end

    describe '.read' do
      it 'returns read messages' do
        unread = create(:message, sender: sender, recipient: recipient, read_at: nil)
        read = create(:message, sender: sender, recipient: recipient, read_at: Time.current)

        expect(Message.read).to include(read)
        expect(Message.read).not_to include(unread)
      end
    end

    describe '.direct_messages' do
      it 'returns messages without project' do
        direct = create(:message, sender: sender, recipient: recipient)
        project_msg = create(:message, :project_message, sender: sender, project: project)

        expect(Message.direct_messages).to include(direct)
        expect(Message.direct_messages).not_to include(project_msg)
      end
    end

    describe '.project_messages' do
      it 'returns messages with project' do
        direct = create(:message, sender: sender, recipient: recipient)
        project_msg = create(:message, :project_message, sender: sender, project: project)

        expect(Message.project_messages).to include(project_msg)
        expect(Message.project_messages).not_to include(direct)
      end
    end

    describe '.conversation_between' do
      it 'returns messages between two users' do
        msg1 = create(:message, sender: sender, recipient: recipient)
        msg2 = create(:message, sender: recipient, recipient: sender)
        other = create(:message, sender: sender, recipient: create(:user))

        conversation = Message.conversation_between(sender, recipient)

        expect(conversation).to include(msg1, msg2)
        expect(conversation).not_to include(other)
      end

      it 'orders by created_at ascending' do
        old_msg = create(:message, sender: sender, recipient: recipient, created_at: 1.hour.ago)
        new_msg = create(:message, sender: recipient, recipient: sender, created_at: Time.current)

        conversation = Message.conversation_between(sender, recipient)

        expect(conversation.first).to eq(old_msg)
        expect(conversation.last).to eq(new_msg)
      end
    end
  end

  describe 'instance methods' do
    describe '#read?' do
      it 'returns true when read_at is present' do
        message = build(:message, read_at: Time.current)
        expect(message.read?).to be true
      end

      it 'returns false when read_at is nil' do
        message = build(:message, read_at: nil)
        expect(message.read?).to be false
      end
    end

    describe '#mark_as_read!' do
      it 'sets read_at when message is unread' do
        message = create(:message, sender: sender, recipient: recipient, read_at: nil)

        expect { message.mark_as_read! }.to change { message.reload.read_at }.from(nil)
      end

      it 'does not update read_at if already read' do
        original_time = 1.hour.ago
        message = create(:message, sender: sender, recipient: recipient, read_at: original_time)

        expect { message.mark_as_read! }.not_to change { message.reload.read_at }
      end
    end

    describe '#direct_message?' do
      it 'returns true when project_id is nil' do
        message = build(:message, project: nil, recipient: recipient)
        expect(message.direct_message?).to be true
      end

      it 'returns false when project_id is present' do
        message = build(:message, :project_message, project: project)
        expect(message.direct_message?).to be false
      end
    end
  end

  describe 'XSS protection' do
    it 'sanitizes HTML content before saving' do
      message = create(:message, sender: sender, recipient: recipient,
                       content: '<script>alert("XSS")</script>Hello')

      expect(message.content).not_to include('<script>')
      expect(message.content).to include('Hello')
    end
  end
end
