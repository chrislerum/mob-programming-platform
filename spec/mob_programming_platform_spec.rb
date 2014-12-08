class MobProgrammingPlatform
  def available_sessions
    []
  end
end

describe "Mob programming platform" do
  it "lists available sessions" do
    expect(MobProgrammingPlatform.new.available_sessions).to be_empty
  end
end
