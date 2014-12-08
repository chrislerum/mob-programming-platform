class MobProgrammingPlatform
  def available_sessions
    @available_sessions ||= []
  end

  def create_session(session_name)
    available_sessions << session_name
  end
end

describe "Mob programming platform" do
  it "lists available sessions" do
    expect(MobProgrammingPlatform.new.available_sessions).to be_empty
  end

  it "creates a named session" do
    platform = MobProgrammingPlatform.new

    platform.create_session("my new session")

    expect(platform.available_sessions.size).to eq(1)
    expect(platform.available_sessions).to include("my new session")
  end
end
