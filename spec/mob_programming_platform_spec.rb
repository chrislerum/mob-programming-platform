class MobProgrammingPlatform
  def available_sessions
    @available_sessions ||= []
  end

  def create_session(session_name)
    raise "You must provide a session name" unless session_name
    available_sessions << session_name
    true
  end
end

describe "Mob programming platform" do
  it "lists available sessions" do
    expect(MobProgrammingPlatform.new.available_sessions).to be_empty
  end

  it "creates a named session" do
    platform = MobProgrammingPlatform.new

    platform.create_session "my new session"

    expect(platform.available_sessions.size).to eq(1)
    expect(platform.available_sessions).to include("my new session")
  end

  it "reports success" do
    platform = MobProgrammingPlatform.new

    response = platform.create_session "successful new session"

    expect(response).to eq(true)
  end

  context "prospective mobster does not provide a session name" do
    it "indicates that the prospective mobster must provide a session name" do
      platform = MobProgrammingPlatform.new

      expect { platform.create_session nil }.
        to raise_error(/You must provide a session name/)
    end

    it "does not create a new session" do
      platform = MobProgrammingPlatform.new

      platform.create_session nil rescue nil

      expect(platform.available_sessions).to be_empty
    end
  end
end
