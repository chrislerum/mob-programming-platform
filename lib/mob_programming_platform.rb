class MobProgrammingPlatform
  def available_sessions
    @available_sessions ||= []
  end

  def create_session(session_name)
    validate_session_name session_name
    validate_session_name_is_available session_name

    available_sessions << session_name
    true
  end

  def join_session(session_name, mobster_name)
    validate_session_name session_name

    @mobster_name = mobster_name
    true
  end

  def active_mobsters(session_name)
    @mobster_name || []
  end

  private

  def validate_session_name(session_name)
    raise "You must provide a session name" unless session_name
  end

  def validate_session_name_is_available(session_name)
    raise "You must provide a different session name" if session?(session_name)
  end

  def session?(session_name)
    available_sessions.include?(session_name)
  end
end
