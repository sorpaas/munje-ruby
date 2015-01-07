class Reader
  def initialize(expression)
    @tokens = expression.scan /[()]|[\w']+/
  end

  def peek
    @tokens.first
  end

  def next_token
    @tokens.shift
  end

  def read
    return :"no more forms" if @tokens.empty?

    if (token = next_token) == '('
      read_list
    else
      token.to_sym
    end
  end

  def read_list
    list = []
    list << read until peek == ')'
    next_token
    list
  end
end
