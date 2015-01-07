class Lisp
  def initialize
    @sexprs = []
  end

  def claim sexpr
    sexpr = to_data(sexpr)
    @sexprs << sexpr
  end

  def resolve
    resolving = @sexprs.dup
    env = initial_env
    while resolving.count != 0
      mark_for_deletion = []
      @sexprs.each do |sexpr|
        if sexpr_resolvable(sexpr, env)
          sexpr_resolve(sexpr, env)
          mark_for_deletion << sexpr
        end
      end
      mark_for_deletion.each do |x|
        resolving.delete(x)
      end
      if mark_for_deletion.count == 0 and resolving.count != 0
        puts "1000000000000 years later: 42."
        raise "Cannot resolve."
      end
    end
    env
  end

  def to_data(sexpr)
    sexpr.map do |x|
      if x.to_s.start_with? "'"
        Value.new(x.to_s[1..-1].to_sym)
      else
        Reference.new(x)
      end
    end
  end

  def sexpr_resolvable(sexpr, env)
    unknown_count = 0
    sexpr.each do |x|
      unknown_count += 1 if x.instance_of? Reference and not env[x.name]
    end
    unknown_count <= 1
  end

  def sexpr_resolve(sexpr, env)
    sexpr_value = sexpr_to_value(sexpr, env)
    rel = sexpr_value[0]
    params = sexpr_value[1..-1]
    result = rel.call params
    result.each_index do |i|
      if sexpr[i + 1].instance_of? Reference
        env[sexpr[i + 1].name] = result[i]
      end
    end
  end

  def sexpr_to_value(sexpr, env)
    sexpr.map do |x|
      if x.instance_of? Reference
        env[x.name]
      else
        x.value
      end
    end
  end

  def initial_env
    {
      :eq => lambda { |(l,r)|
        if l and r and l != r
          raise "Cannot resolve variables."
        end
        if not l and not r
          raise "Not implemented."
        end

        l = r if r
        r = l if l
        [l, r]
      }
    }
  end
end

class Reference
  def initialize(atom)
    @atom = atom
  end

  def name
    @atom
  end
end

class Value
  def initialize(value)
    @value = value
  end

  def value
    @value
  end
end
