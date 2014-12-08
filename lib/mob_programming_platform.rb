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
    validate_session_is_current session_name
    validate_mobster_name mobster_name
    validate_session_does_not_include_mobster(session_name, mobster_name)
    validate_mobster_is_not_currently_active mobster_name

    active_mobsters(session_name) << mobster_name
    true
  end

  def active_mobsters(session_name)
    @active_mobsters ||= {}
    @active_mobsters[session_name] ||= []
  end

  private

  def validate_mobster_name(mobster_name)
    raise "You must provide your name" unless mobster_name
  end

  def validate_session_name(session_name)
    raise "You must provide a session name" unless session_name
  end

  def validate_session_name_is_available(session_name)
    raise "You must provide a different session name" if session?(session_name)
  end

  def validate_session_is_current(session_name)
    unless session?(session_name)
      raise "You must provide the name of a current session"
    end
  end

  def validate_session_does_not_include_mobster(session_name, mobster_name)
    if active_mobsters(session_name).include?(mobster_name)
      raise "You may not join the same session twice"
    end
  end

  def validate_mobster_is_not_currently_active(mobster_name)
    if active_mobster?(mobster_name)
      raise "You cannot join two sessions at the same time"
    end
  end

  def session?(session_name)
    available_sessions.include?(session_name)
  end

  def active_mobster?(mobster_name)
    available_sessions.any? {|s| active_mobsters(s).include?(mobster_name) }
  end
end
