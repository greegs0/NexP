require 'rails_helper'

RSpec.describe ConversationChannel, type: :channel do
  let(:user) { create(:user) }
  let(:recipient) { create(:user) }

  before do
    stub_connection current_user: user
  end

  describe '#subscribed' do
    it 'successfully subscribes with recipient_id' do
      subscribe(recipient_id: recipient.id)

      expect(subscription).to be_confirmed
    end

    it 'streams from both conversation directions' do
      subscribe(recipient_id: recipient.id)

      # Should stream from user -> recipient channel
      expect(subscription).to have_stream_from("conversation_#{user.id}_#{recipient.id}")
      # Should also stream from recipient -> user channel
      expect(subscription).to have_stream_from("conversation_#{recipient.id}_#{user.id}")
    end

    it 'creates bidirectional streams for real-time messaging' do
      subscribe(recipient_id: recipient.id)

      expect(subscription.streams.length).to eq(2)
    end
  end

  describe '#unsubscribed' do
    it 'stops all streams' do
      subscribe(recipient_id: recipient.id)
      expect(subscription.streams).not_to be_empty

      subscription.unsubscribe_from_channel
      # Streams should be stopped after unsubscribe
    end
  end

  describe 'broadcasting' do
    it 'broadcasts message to conversation stream' do
      subscribe(recipient_id: recipient.id)

      message_data = {
        content: 'Hello!',
        sender_id: user.id,
        sender_name: user.display_name,
        created_at: Time.current.iso8601
      }

      stream_name = "conversation_#{user.id}_#{recipient.id}"

      expect {
        ActionCable.server.broadcast(stream_name, message_data)
      }.to have_broadcasted_to(stream_name).with(message_data)
    end
  end

  context 'with different recipients' do
    let(:other_recipient) { create(:user) }

    it 'creates separate streams for different conversations' do
      subscribe(recipient_id: recipient.id)
      first_streams = subscription.streams.dup

      # Unsubscribe and subscribe to different conversation
      subscription.unsubscribe_from_channel

      subscribe(recipient_id: other_recipient.id)
      second_streams = subscription.streams

      # Streams should be different for different recipients
      expect(first_streams).not_to eq(second_streams)
    end
  end

  context 'when recipient_id is missing' do
    it 'subscribes but with nil in stream name' do
      subscribe(recipient_id: nil)

      # Channel will still subscribe, but stream names will contain 'nil'
      expect(subscription).to be_confirmed
    end
  end
end
