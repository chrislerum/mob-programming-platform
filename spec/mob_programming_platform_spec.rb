require 'mob_programming_platform'

describe "Mob Programming Platform (MPP)" do
  it "a prospective mobster (PM) lists available sessions" do
    expect(MobProgrammingPlatform.new.available_sessions).to be_empty
  end

  describe "a prospective mobster (PM) creates a new session" do
    it "MPP adds a new named session to the available sessions list" do
      platform = MobProgrammingPlatform.new

      platform.create_session "my new session"

      expect(platform.available_sessions.size).to eq(1)
      expect(platform.available_sessions).to include("my new session")
    end

    it "MPP reports success" do
      platform = MobProgrammingPlatform.new

      response = platform.create_session "successful new session"

      expect(response).to eq(true)
    end

    context "PM does not provide a session name" do
      it "MPP indicates that the PM must provide a session name" do
        platform = MobProgrammingPlatform.new

        expect { platform.create_session nil }.
          to raise_error(/You must provide a session name/)
      end

      it "MPP does not create a new session" do
        platform = MobProgrammingPlatform.new

        platform.create_session nil rescue nil

        expect(platform.available_sessions).to be_empty
      end
    end

    context "PM provides the name of an existing session" do
      it "MPP indicates that the PM must provide a different name" do
        platform = MobProgrammingPlatform.new

        platform.create_session "my session name"

        expect { platform.create_session "my session name" }.
          to raise_error(/You must provide a different session name/)
      end

      it "MPP does not create a new session" do
        platform = MobProgrammingPlatform.new

        first_session_name = "my session name"

        platform.create_session first_session_name
        platform.create_session "my session name" rescue nil

        expect(platform.available_sessions.size).to eq(1)
        expect(platform.available_sessions.first.object_id).
          to eq(first_session_name.object_id)
      end
    end
  end
end
