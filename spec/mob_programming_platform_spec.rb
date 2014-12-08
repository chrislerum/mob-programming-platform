class MobProgrammingPlatform
  def available_sessions
    @available_sessions ||= []
  end

  def create_session
    available_sessions << :new_session
  end
end

describe "Mob programming platform" do
  it "lists available sessions" do
    expect(MobProgrammingPlatform.new.available_sessions).to be_empty
  end

  it "creates new sessions" do
    platform = MobProgrammingPlatform.new
    platform.create_session
    expect(platform.available_sessions.size).to eq(1)
  end
end
