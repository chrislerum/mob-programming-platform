class MobProgrammingPlatform
  def available_sessions
    []
  end
end

describe "Mob programming platform" do
  it "has a passing test" do
    expect(1).to be_odd
  end

  it "lists available sessions" do
    expect(MobProgrammingPlatform.new.available_sessions).to be_empty
  end
end
