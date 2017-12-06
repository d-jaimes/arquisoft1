class EmailBuilder
  def self.build
    builder = new
    yield(builder)
    builder.email
  end

  def initialize
    @email = Email.new
  end

  def set_subject(subject)
    @email.subject = subject
  end

  def set_body(body)
    @email.body = body
  end

  def set_to(to)
    @email.to = to
  end

  def set_from(from)
    @email.from = from
  end

  def email
    @email
  end
end
