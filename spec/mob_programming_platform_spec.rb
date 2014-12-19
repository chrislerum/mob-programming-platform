require 'mob_programming_platform'

class InMemoryMailingService
  def emails_sent
    @emails_sent ||= []
  end

  def deliver_email(email, subject)
    emails_sent << "#{subject}, #{email}"
  end
end

describe "Mob Programming Platform (MPP)" do
  it "starts off with no available sessions" do
    expect(mpp.available_sessions).to be_empty
  end

  let(:mpp) { MobProgrammingPlatform.new(mailing_service) }
  let(:mailing_service) { double('mailing service') }

  let(:pm_name) { "PM name" }
  let(:session_name) { "session name" }

  describe "when a RubySteps prospect creates an account" do
    before { allow(mailing_service).to receive(:deliver_email) }

    it "sends a confirmation email to the prospect's email address" do
      expect(mailing_service).to receive(:deliver_email).with("prospect@example.com", "Welcome to MPP")

      mpp.register name: 'RubySteps prospect', username: 'prospect', email: 'prospect@example.com'
    end

    it "sends a confirmation email to the prospect's email address (state-based)" do
      in_memory_mailing_service = InMemoryMailingService.new
      expect(in_memory_mailing_service.emails_sent).to be_empty

      mpp = MobProgrammingPlatform.new in_memory_mailing_service

      mpp.register name: 'RubySteps prospect', username: 'prospect', email: 'prospect@example.com'

      expect(in_memory_mailing_service.emails_sent).to include("Welcome to MPP, prospect@example.com")
    end

    it "indicates that a confirmation email was sent" do
      expect(mpp.system_messages).to be_empty

      mpp.register name: 'RubySteps prospect', username: 'prospect', email: 'prospect@example.com'

      expect(mpp.system_messages).to include("RubySteps prospect, check your email for a confirmation link")
    end

    it "handles arbitrary names in the confirmation email" do
      mpp.register name: 'another RubySteps prospect', username: 'prospect', email: 'prospect@example.com'

      expect(mpp.system_messages).to include("another RubySteps prospect, check your email for a confirmation link")
    end

    #    RubySteps prospect provides registration information
    #    Mob Programming Platform validates email and username availability
    #    Mob Programming Platform sends RubySteps prospect a confirmation email and indicates that it was sent
  end

  describe "when a prospective mobster (PM) creates a new session" do
    it "adds a new named session to the available sessions list" do
      mpp.create_session session_name

      expect(mpp.available_sessions).to eq([session_name])
    end

    it "reports success" do
      response = mpp.create_session session_name

      expect(response).to eq(true)
    end

    context "when the PM does not provide a session name" do
      def create_session_without_name
        mpp.create_session nil
      end

      it "indicates that the PM must provide a session name" do
        expect { create_session_without_name }.
          to raise_error(/You must provide a session name/)
      end

      it "does not create a new session" do
        create_session_without_name rescue nil

        expect(mpp.available_sessions).to be_empty
      end
    end

    context "when PM provides the name of an existing session" do
      def create_session
        mpp.create_session session_name
      end

      it "indicates that the PM must provide a different name" do
        create_session

        expect { create_session }.
          to raise_error(/You must provide a different session name/)
      end

      it "does not create a new session" do
        create_session
        create_session rescue nil

        expect(mpp.available_sessions).
          to eq([session_name])
      end
    end
  end

  describe "when a Prospective Mobster (PM) joins a session" do
    it "adds PM to the list of active mobsters" do
      mpp.create_session session_name

      mpp.join_session session_name, pm_name

      expect(mpp.active_mobsters(session_name)).to include(pm_name)
    end

    it "reports success" do
      mpp.create_session session_name

      expect(mpp.join_session(session_name, pm_name)).to eq(true)
    end

    context "when PM does not provide the name of a session to join" do
      def join_session_with_pm_name_without_session_name
        mpp.join_session nil, pm_name
      end

      it "indicates that the PM must provide a session name" do
        expect { join_session_with_pm_name_without_session_name }.
          to raise_error(/You must provide a session name/)
      end

      it "does not add PM to the list of active mobsters" do
        join_session_with_pm_name_without_session_name rescue nil

        expect(mpp.active_mobsters(nil)).to_not include(pm_name)
      end
    end

    context "when PM does not provide their name" do
      def join_session_with_session_name_without_pm_name
        mpp.join_session session_name, nil
      end

      it "indicates that PM must provide their name" do
        mpp.create_session session_name

        expect { join_session_with_session_name_without_pm_name }.
          to raise_error(/You must provide your name/)
      end

      it "does not add PM to the list of active mobsters" do
        mpp.create_session session_name
        join_session_with_session_name_without_pm_name rescue nil

        expect(mpp.active_mobsters(session_name)).to be_empty
      end
    end

    context "when PM provides the name of a session that does not exist" do
      def join_nonexistent_session
        mpp.join_session session_name, pm_name
      end

      it "indicates that PM must provide the name of a current session" do
        expect { join_nonexistent_session }.
          to raise_error(/You must provide the name of a current session/)
      end

      it "does not add PM to the list of active mobsters" do
        join_nonexistent_session rescue nil

        expect(mpp.active_mobsters(session_name)).to be_empty
      end
    end

    context "when PM joins a session in which they're already participating" do
      before { mpp.create_session session_name }

      def join_session
        mpp.join_session session_name, pm_name
      end

      it "indicates that PM may not join the same session twice" do
        join_session

        expect { join_session }.
          to raise_error(/You may not join the same session twice/)
      end

      it "does not modify the list of active mobsters" do
        join_session
        join_session rescue nil

        expect(mpp.active_mobsters(session_name)).
          to eq([pm_name])
      end
    end
  end

  context "when PM joins session while already participating in another session" do
    let(:first_session_name) { "first session" }

    before do
      mpp.create_session first_session_name
      mpp.join_session first_session_name, pm_name
      mpp.create_session session_name
    end

    def join_second_session
      mpp.join_session session_name, pm_name
    end

    it "indicates that PM cannot join two sessions at the same time" do
      expect { join_second_session }.
        to raise_error(/You cannot join two sessions at the same time/)
    end

    it "does not modify list of active mobsters for the first session" do
      join_second_session rescue nil

      expect(mpp.active_mobsters(first_session_name)).
        to eq([pm_name])
    end

    it "does not add PM to list of active mobsters for second session" do
      join_second_session rescue nil

      expect(mpp.active_mobsters(session_name)).to be_empty
    end
  end
end
