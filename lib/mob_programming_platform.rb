class MobProgrammingPlatform
  def available_sessions
    @available_sessions ||= []
  end

  def create_session(session_name)
    validate_session_name session_name

    available_sessions << session_name
    true
  end

  private

  def validate_session_name(session_name)
    if session_name.nil?
      raise "You must provide a session name"
    elsif available_sessions.include?(session_name)
      raise "You must provide a different session name"
    end
  end
end
